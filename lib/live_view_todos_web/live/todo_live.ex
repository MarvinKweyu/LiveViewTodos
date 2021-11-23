defmodule LiveViewTodosWeb.TodoLive do
  use LiveViewTodosWeb, :live_view
  alias LiveViewTodos.Todos

  def mount(_params, _session, socket) do
    # {:ok, assign(socket, todos: Todos.list_todos())}
    Todos.subscribe()
    {:ok, fetch(socket)}
  end

  # use in larger projects instead of html todo_live file
  # def render(assigns) do
  #   ~L"Rendering LiveView"
  # end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)
    # since PubSub is fetching all todos in all requests, remove the below
    # {:noreply, fetch(socket)}
    {:noreply, socket}
  end

  def handle_event("toggle_done", %{"id" => id}, socket) do
    # fetch todo from db
    todo = Todos.get_todo!(id)
    # change todo to the opposite
    Todos.update_todo(todo, %{done: !todo.done})
    # remove due to comment 18
    # {:noreply, fetch(socket)}
    {:noreply, socket}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end
