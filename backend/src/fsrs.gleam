import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/result
import gleam/time/timestamp

// Type definitions

pub type Parameters {
  Parameters(
    request_retention: Float,
    maximum_interval: Int,
    weights: #(
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
    ),
  )
}

pub fn default_parameters() -> Parameters {
  Parameters(request_retention: 0.9, maximum_interval: 36_500, weights: #(
    0.4,
    0.6,
    2.4,
    5.8,
    4.93,
    0.94,
    0.86,
    0.01,
    1.49,
    0.14,
    0.94,
    2.18,
    0.05,
    0.34,
    1.26,
    0.29,
    2.61,
  ))
}

// In Gleam, we'll need to implement our own DateTime struct
// since it's not built-in like in Elixir
pub type DateTime {
  DateTime(seconds: Int)
}

pub fn utc_now() -> DateTime {
  // In a real implementation, this would return the current time
  // For this translation, we're keeping it simple
  DateTime(seconds: 0)
}

pub fn datetime_add(dt: DateTime, value: Int, unit: TimeUnit) -> DateTime {
  case unit {
    Day -> DateTime(seconds: dt.seconds + value * 86_400)
    Minute -> DateTime(seconds: dt.seconds + value * 60)
  }
}

pub fn datetime_diff(dt1: DateTime, dt2: DateTime, unit: TimeUnit) -> Int {
  let diff = dt1.seconds - dt2.seconds
  case unit {
    Day -> diff / 86_400
    Minute -> diff / 60
  }
}

pub type TimeUnit {
  Day
  Minute
}

pub type CardState {
  New
  Learning
  Review
  Relearning
}

pub type Card {
  Card(
    due: DateTime,
    stability: Float,
    difficulty: Float,
    elapsed_days: Int,
    scheduled_days: Int,
    reps: Int,
    lapses: Int,
    state: CardState,
    last_review: DateTime,
  )
}

pub fn new_card() -> Card {
  let now = utc_now()
  Card(
    due: now,
    stability: 0.0,
    difficulty: 0.0,
    elapsed_days: 0,
    scheduled_days: 0,
    reps: 0,
    lapses: 0,
    state: New,
    last_review: now,
  )
}

pub fn get_retrievability(card: Card, now: DateTime) -> Float {
  case card.state {
    Review -> {
      let elapsed_days = int.max(0, datetime_diff(now, card.last_review, Day))
      float.power(
        1.0 +. int.to_float(elapsed_days) /. { 9.0 *. card.stability },
        -1.0,
      )
      |> result.unwrap(1.0)
    }
    _ -> 0.0
  }
}

pub type Rating {
  Again
  Hard
  Good
  Easy
}

pub type ReviewLog {
  ReviewLog(
    rating: Rating,
    elapsed_days: Int,
    scheduled_days: Int,
    review: DateTime,
    state: CardState,
  )
}

pub type SchedulingInfo {
  SchedulingInfo(card: Card, review_log: ReviewLog)
}

pub type SchedulingCards {
  SchedulingCards(again: Card, hard: Card, good: Card, easy: Card)
}

pub fn update_state(
  scheduling_cards: SchedulingCards,
  state: CardState,
) -> SchedulingCards {
  case state {
    New -> {
      let again =
        Card(
          ..scheduling_cards.again,
          state: Learning,
          lapses: scheduling_cards.again.lapses + 1,
        )
      let hard = Card(..scheduling_cards.hard, state: Learning)
      let good = Card(..scheduling_cards.good, state: Learning)
      let easy = Card(..scheduling_cards.easy, state: Review)
      SchedulingCards(again: again, hard: hard, good: good, easy: easy)
    }
    Review -> {
      let again =
        Card(
          ..scheduling_cards.again,
          state: Relearning,
          lapses: scheduling_cards.again.lapses + 1,
        )
      let hard = Card(..scheduling_cards.hard, state: Review)
      let good = Card(..scheduling_cards.good, state: Review)
      let easy = Card(..scheduling_cards.easy, state: Review)
      SchedulingCards(again: again, hard: hard, good: good, easy: easy)
    }
    _ -> {
      let again = Card(..scheduling_cards.again, state: state)
      let hard = Card(..scheduling_cards.hard, state: state)
      let good = Card(..scheduling_cards.good, state: Review)
      let easy = Card(..scheduling_cards.easy, state: Review)
      SchedulingCards(again: again, hard: hard, good: good, easy: easy)
    }
  }
}

pub fn schedule(
  scheduling_cards: SchedulingCards,
  now: DateTime,
  hard_interval: Int,
  good_interval: Int,
  easy_interval: Int,
) -> SchedulingCards {
  let hard_due = case hard_interval {
    interval if interval > 0 -> datetime_add(now, hard_interval, Day)
    _ -> datetime_add(now, 10, Minute)
  }

  let again =
    Card(
      ..scheduling_cards.again,
      scheduled_days: 0,
      due: datetime_add(now, 5, Minute),
    )

  let hard =
    Card(..scheduling_cards.hard, scheduled_days: hard_interval, due: hard_due)

  let good =
    Card(
      ..scheduling_cards.good,
      scheduled_days: good_interval,
      due: datetime_add(now, good_interval, Day),
    )

  let easy =
    Card(
      ..scheduling_cards.easy,
      scheduled_days: easy_interval,
      due: datetime_add(now, easy_interval, Day),
    )

  SchedulingCards(again: again, hard: hard, good: good, easy: easy)
}

pub fn record_log(
  scheduling_cards: SchedulingCards,
  card: Card,
  now: DateTime,
) -> Dict(Rating, SchedulingInfo) {
  dict.new()
  |> dict.insert(
    Again,
    SchedulingInfo(
      card: scheduling_cards.again,
      review_log: ReviewLog(
        rating: Again,
        scheduled_days: scheduling_cards.again.scheduled_days,
        elapsed_days: card.elapsed_days,
        review: now,
        state: card.state,
      ),
    ),
  )
  |> dict.insert(
    Hard,
    SchedulingInfo(
      card: scheduling_cards.hard,
      review_log: ReviewLog(
        rating: Hard,
        scheduled_days: scheduling_cards.hard.scheduled_days,
        elapsed_days: card.elapsed_days,
        review: now,
        state: card.state,
      ),
    ),
  )
  |> dict.insert(
    Good,
    SchedulingInfo(
      card: scheduling_cards.good,
      review_log: ReviewLog(
        rating: Good,
        scheduled_days: scheduling_cards.good.scheduled_days,
        elapsed_days: card.elapsed_days,
        review: now,
        state: card.state,
      ),
    ),
  )
  |> dict.insert(
    Easy,
    SchedulingInfo(
      card: scheduling_cards.easy,
      review_log: ReviewLog(
        rating: Easy,
        scheduled_days: scheduling_cards.easy.scheduled_days,
        elapsed_days: card.elapsed_days,
        review: now,
        state: card.state,
      ),
    ),
  )
}

// FSRS algorithm implementation

fn mean_reversion(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  init: Float,
  current: Float,
) -> Float {
  let #(_, _, _, _, _, _, _, w7, _, _, _, _, _, _, _, _, _) = weights
  w7 *. init +. { 1.0 -. w7 } *. current
}

fn init_stability(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  r: Int,
) -> Float {
  let stability = case r {
    1 -> {
      let #(w0, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _) = weights
      w0
    }
    2 -> {
      let #(_, w1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _) = weights
      w1
    }
    3 -> {
      let #(_, _, w2, _, _, _, _, _, _, _, _, _, _, _, _, _, _) = weights
      w2
    }
    _ -> 0.0
  }
  float.max(stability, 0.1)
}

fn init_difficulty(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  r: Int,
) -> Float {
  let #(_, _, _, _, w4, w5, _, _, _, _, _, _, _, _, _, _, _) = weights
  float.min(float.max(w4 -. w5 *. int.to_float(r - 3), 1.0), 10.0)
}

fn next_interval(params: Parameters, s: Float) -> Int {
  let new_interval = s *. 9.0 *. { 1.0 /. params.request_retention -. 1.0 }
  int.min(int.max(float.round(new_interval), 1), params.maximum_interval)
}

fn next_difficulty(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  d: Float,
  r: Int,
) -> Float {
  let #(_, _, _, _, w4, _, w6, _, _, _, _, _, _, _, _, _, _) = weights
  let next_d = d -. w6 *. int.to_float(r - 3)
  float.min(float.max(mean_reversion(weights, w4, next_d), 1.0), 10.0)
}

fn next_recall_stability(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  d: Float,
  s: Float,
  r: Float,
  rating: Int,
) -> Float {
  let #(_, _, _, _, _, _, _, _, w8, w9, w10, _, _, _, _, w15, w16) = weights

  let exp_w8 = float.exponential(w8)
  let pow_s = float.power(s, -1.0 *. w9) |> result.unwrap(1.0)
  let exp_r = float.exponential({ 1.0 -. r } *. w10)

  let base =
    s *. { 1.0 +. exp_w8 *. { 11.0 -. d } *. pow_s *. { exp_r -. 1.0 } }

  case rating {
    2 -> base *. w15
    4 -> base *. w16
    _ -> base
  }
}

fn next_forget_stability(
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  d: Float,
  s: Float,
  r: Float,
) -> Float {
  let #(_, _, _, _, _, _, _, _, _, _, _, w11, w12, w13, w14, _, _) = weights

  let pow_d = float.power(d, -1.0 *. w12) |> result.unwrap(1.0)
  let pow_s = float.power(s +. 1.0, w13) |> result.unwrap(1.0)
  let exp_r = float.exponential({ 1.0 -. r } *. w14)
  w11 *. pow_d *. { pow_s -. 1.0 } *. exp_r
}

fn init_ds(
  s: SchedulingCards,
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
) -> SchedulingCards {
  let again =
    Card(
      ..s.again,
      difficulty: init_difficulty(weights, 1),
      stability: init_stability(weights, 1),
    )
  let hard =
    Card(
      ..s.hard,
      difficulty: init_difficulty(weights, 2),
      stability: init_stability(weights, 2),
    )
  let good =
    Card(
      ..s.good,
      difficulty: init_difficulty(weights, 3),
      stability: init_stability(weights, 3),
    )
  let easy =
    Card(
      ..s.easy,
      difficulty: init_difficulty(weights, 4),
      stability: init_stability(weights, 4),
    )

  SchedulingCards(again: again, hard: hard, good: good, easy: easy)
}

fn next_ds(
  s: SchedulingCards,
  weights: #(
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
    Float,
  ),
  last_d: Float,
  last_s: Float,
  retrievability: Float,
) -> SchedulingCards {
  let again_difficulty = next_difficulty(weights, last_d, 1)
  let hard_difficulty = next_difficulty(weights, last_d, 2)
  let good_difficulty = next_difficulty(weights, last_d, 3)
  let easy_difficulty = next_difficulty(weights, last_d, 4)

  let again_stability =
    next_forget_stability(weights, again_difficulty, last_s, retrievability)
  let hard_stability =
    next_recall_stability(weights, hard_difficulty, last_s, retrievability, 2)
  let good_stability =
    next_recall_stability(weights, good_difficulty, last_s, retrievability, 3)
  let easy_stability =
    next_recall_stability(weights, easy_difficulty, last_s, retrievability, 4)

  let again =
    Card(..s.again, difficulty: again_difficulty, stability: again_stability)
  let hard =
    Card(..s.hard, difficulty: hard_difficulty, stability: hard_stability)
  let good =
    Card(..s.good, difficulty: good_difficulty, stability: good_stability)
  let easy =
    Card(..s.easy, difficulty: easy_difficulty, stability: easy_stability)

  SchedulingCards(again: again, hard: hard, good: good, easy: easy)
}

pub fn repeat(
  params: Parameters,
  card: Card,
  now: DateTime,
) -> Dict(Rating, SchedulingInfo) {
  case card.state {
    New -> {
      let updated_card =
        Card(..card, elapsed_days: 0, last_review: now, reps: card.reps + 1)

      let s =
        SchedulingCards(
          again: updated_card,
          hard: updated_card,
          good: updated_card,
          easy: updated_card,
        )

      let s = update_state(s, New)
      let s = init_ds(s, params.weights)

      let easy_interval = next_interval(params, s.easy.stability)

      let again = Card(..s.again, due: datetime_add(now, 1, Minute))
      let hard = Card(..s.hard, due: datetime_add(now, 5, Minute))
      let good = Card(..s.good, due: datetime_add(now, 10, Minute))
      let easy =
        Card(
          ..s.easy,
          due: datetime_add(now, easy_interval, Day),
          scheduled_days: easy_interval,
        )

      let final_s =
        SchedulingCards(again: again, hard: hard, good: good, easy: easy)

      record_log(final_s, updated_card, now)
    }

    Review -> {
      let elapsed_days = datetime_diff(now, card.last_review, Day)

      let updated_card =
        Card(
          ..card,
          elapsed_days: elapsed_days,
          last_review: now,
          reps: card.reps + 1,
        )

      let last_s = card.stability
      let last_d = card.difficulty

      let power_result =
        float.power(
          1.0 +. int.to_float(elapsed_days) /. { 9.0 *. last_s },
          -1.0,
        )
      let retrievability = result.unwrap(power_result, 1.0)

      let s =
        SchedulingCards(
          again: updated_card,
          hard: updated_card,
          good: updated_card,
          easy: updated_card,
        )

      let s = update_state(s, Review)
      let s = next_ds(s, params.weights, last_d, last_s, retrievability)

      let hard_interval = next_interval(params, s.hard.stability)
      let good_interval = next_interval(params, s.good.stability)
      let hard_interval = int.min(hard_interval, good_interval)
      let good_interval = int.max(good_interval, hard_interval + 1)
      let easy_interval =
        int.max(next_interval(params, s.easy.stability), good_interval + 1)

      let final_s =
        schedule(s, now, hard_interval, good_interval, easy_interval)

      record_log(final_s, updated_card, now)
    }

    _ -> {
      let updated_card =
        Card(
          ..card,
          elapsed_days: datetime_diff(now, card.last_review, Day),
          last_review: now,
          reps: card.reps + 1,
        )

      let s =
        SchedulingCards(
          again: updated_card,
          hard: updated_card,
          good: updated_card,
          easy: updated_card,
        )

      let s = update_state(s, card.state)

      let hard_interval = 0
      let good_interval = next_interval(params, s.good.stability)
      let easy_interval =
        int.max(next_interval(params, s.easy.stability), good_interval + 1)

      let final_s =
        schedule(s, now, hard_interval, good_interval, easy_interval)

      record_log(final_s, updated_card, now)
    }
  }
}
