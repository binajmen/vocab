import { createFileRoute } from '@tanstack/solid-router'

export const Route = createFileRoute('/hello')({
  component: RouteComponent,
})

function RouteComponent() {
  return <div>Hello "/hello"!</div>
}
