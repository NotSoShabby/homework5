defmodule Takso.DriverChannel do
  use Takso.Web, :channel
  use Guardian.Channel

  def join("driver:"<>owner, %{claims: _, resource: %{username: username}}, socket)
  when username == owner do
    {:ok, socket}
  end
  
  def join(_room, _, socket) do
    {:error, :unauthorized}
  end
end