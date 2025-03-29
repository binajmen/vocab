import fsrs.{
  type Card, type DateTime, type Parameters, type Rating, type ReviewLog,
  type SchedulingInfo, Again, Card, DateTime, Easy, Good, Hard, Learning, New,
  Parameters, Relearning, Review, SchedulingInfo, datetime_diff,
  get_retrievability, new_card, repeat, utc_now,
}
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Helper function to create a DateTime from an ISO 8601 string
pub fn from_iso8601(iso_string: String) -> DateTime {
  // In a real implementation, we'd parse the ISO string
  // For simplicity in this test, we'll use predetermined timestamp values
  case iso_string {
    "2022-11-29T12:30:00Z" -> DateTime(seconds: 1_669_727_400)
    "2023-06-01T12:30:00Z" -> DateTime(seconds: 1_685_621_400)
    "2023-12-01T12:30:00Z" -> DateTime(seconds: 1_701_432_600)
    _ -> DateTime(seconds: 0)
  }
}

// Helper function equivalent to generate_test_cards in the Elixir test
fn generate_test_cards() -> #(
  Parameters,
  Dict(Rating, SchedulingInfo),
  DateTime,
) {
  let weights = #(
    1.14,
    1.01,
    5.44,
    14.67,
    5.3024,
    1.5662,
    1.2503,
    0.0028,
    1.5489,
    0.1763,
    0.9953,
    2.7473,
    0.0179,
    0.3105,
    0.3976,
    0.0,
    2.0902,
  )

  let params =
    Parameters(
      request_retention: 0.9,
      maximum_interval: 36_500,
      weights: weights,
    )

  let card = new_card()
  let now = from_iso8601("2022-11-29T12:30:00Z")

  #(params, repeat(params, card, now), now)
}

pub fn scheduling_test() {
  let ratings = [
    Good,
    Good,
    Good,
    Good,
    Good,
    Good,
    Again,
    Again,
    Good,
    Good,
    Good,
    Good,
    Good,
  ]

  let #(params, scheduling_info, _) = generate_test_cards()

  let #(final_scheduling, intervals) =
    list.fold(ratings, #(scheduling_info, []), fn(acc, rating) {
      let #(curr_scheduling, intervals) = acc

      let card_info =
        dict.get(curr_scheduling, rating)
        |> result.unwrap(SchedulingInfo(
          card: new_card(),
          review_log: fsrs.ReviewLog(
            rating: Good,
            elapsed_days: 0,
            scheduled_days: 0,
            review: utc_now(),
            state: New,
          ),
        ))

      let card = card_info.card
      let interval = card.scheduled_days
      let new_scheduling_info = repeat(params, card, card.due)

      #(new_scheduling_info, [interval, ..intervals])
    })

  let expected = [0, 5, 16, 43, 106, 236, 0, 0, 12, 25, 47, 85, 147]
  list.reverse(intervals) |> should.equal(expected)

  let good_card_info =
    dict.get(final_scheduling, Good)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Good,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let retrievability =
    get_retrievability(good_card_info.card, good_card_info.card.due)
  float.to_precision(retrievability, 13) |> should.equal(0.9000082565264)
}

pub fn first_review_test() {
  let #(_, scheduling_info, _) = generate_test_cards()

  // Test Again card
  let again_card_info =
    dict.get(scheduling_info, Again)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Again,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let again_card = again_card_info.card
  again_card.due |> should.equal(DateTime(seconds: 1_669_727_460))
  // 2022-11-29 12:31:00Z
  float.to_precision(again_card.stability, 2) |> should.equal(1.14)
  float.to_precision(again_card.difficulty, 4) |> should.equal(8.4348)
  again_card.elapsed_days |> should.equal(0)
  again_card.scheduled_days |> should.equal(0)
  again_card.reps |> should.equal(1)
  again_card.lapses |> should.equal(1)
  again_card.state |> should.equal(Learning)
  again_card.last_review |> should.equal(DateTime(seconds: 1_669_727_400))
  // 2022-11-29 12:30:00Z

  // Test Hard card
  let hard_card_info =
    dict.get(scheduling_info, Hard)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Hard,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let hard_card = hard_card_info.card
  hard_card.due |> should.equal(DateTime(seconds: 1_669_727_700))
  // 2022-11-29 12:35:00Z
  float.to_precision(hard_card.stability, 2) |> should.equal(1.01)
  float.to_precision(hard_card.difficulty, 4) |> should.equal(6.8686)
  hard_card.elapsed_days |> should.equal(0)
  hard_card.scheduled_days |> should.equal(0)
  hard_card.reps |> should.equal(1)
  hard_card.lapses |> should.equal(0)
  hard_card.state |> should.equal(Learning)
  hard_card.last_review |> should.equal(DateTime(seconds: 1_669_727_400))
  // 2022-11-29 12:30:00Z

  // Test Good card
  let good_card_info =
    dict.get(scheduling_info, Good)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Good,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let good_card = good_card_info.card
  good_card.due |> should.equal(DateTime(seconds: 1_669_728_000))
  // 2022-11-29 12:40:00Z
  float.to_precision(good_card.stability, 2) |> should.equal(5.44)
  float.to_precision(good_card.difficulty, 4) |> should.equal(5.3024)
  good_card.elapsed_days |> should.equal(0)
  good_card.scheduled_days |> should.equal(0)
  good_card.reps |> should.equal(1)
  good_card.lapses |> should.equal(0)
  good_card.state |> should.equal(Learning)
  good_card.last_review |> should.equal(DateTime(seconds: 1_669_727_400))
  // 2022-11-29 12:30:00Z

  // Test Easy card
  let easy_card_info =
    dict.get(scheduling_info, Easy)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Easy,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let easy_card = easy_card_info.card
  easy_card.due |> should.equal(DateTime(seconds: 1_671_024_600))
  // 2022-12-14 12:30:00Z
  float.to_precision(easy_card.stability, 2) |> should.equal(14.67)
  float.to_precision(easy_card.difficulty, 4) |> should.equal(3.7362)
  easy_card.elapsed_days |> should.equal(0)
  easy_card.scheduled_days |> should.equal(15)
  easy_card.reps |> should.equal(1)
  easy_card.lapses |> should.equal(0)
  easy_card.state |> should.equal(Review)
  easy_card.last_review |> should.equal(DateTime(seconds: 1_669_727_400))
  // 2022-11-29 12:30:00Z
}

pub fn elapsed_days_test() {
  let #(params, scheduling_info, _) = generate_test_cards()

  let good_card_info =
    dict.get(scheduling_info, Good)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Good,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let card = good_card_info.card
  let future_date_1 = from_iso8601("2023-06-01T12:30:00Z")

  let scheduling_info_2 = repeat(params, card, future_date_1)
  let good_card_info_2 =
    dict.get(scheduling_info_2, Good)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Good,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let card_2 = good_card_info_2.card
  let future_date_2 = from_iso8601("2023-12-01T12:30:00Z")

  let scheduling_info_3 = repeat(params, card_2, future_date_2)
  let good_card_info_3 =
    dict.get(scheduling_info_3, Good)
    |> result.unwrap(SchedulingInfo(
      card: new_card(),
      review_log: fsrs.ReviewLog(
        rating: Good,
        elapsed_days: 0,
        scheduled_days: 0,
        review: utc_now(),
        state: New,
      ),
    ))

  let card_3 = good_card_info_3.card

  float.to_precision(card_3.stability, 13) |> should.equal(134.5276128635202)

  let retrievability = get_retrievability(card_3, card_3.due)
  float.to_precision(retrievability, 16) |> should.equal(0.8996840803331014)
}
