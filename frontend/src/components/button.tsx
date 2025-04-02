import type { ComponentProps } from "solid-js";

type ButtonGroupProps = ComponentProps<"div">;

export function ButtonGroup(props: ButtonGroupProps) {
  return (
    <div {...props} class="inline-grid grid-flow-col auto-cols-fr gap-8" />
  );
}
