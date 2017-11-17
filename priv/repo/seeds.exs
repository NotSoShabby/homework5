alias Takso.{Repo,User,Taxi}

[%{name: "Fred Flintstone", username: "fred", password: "parool", role: "customer"},
 %{name: "Barney Rubble", username: "barney", password: "parool", role: "customer"},
 %{name: "Bilbo Baggins", username: "bilbo", password: "parool", role: "taxi-driver"},
 %{name: "Frodo Baggins", username: "frodo", password: "parool", role: "taxi-driver"}]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[%{username: "bilbo", location: "Uus turu 2", status: "available"},
 %{username: "frodo", location: "Raatuse 22", status: "available"}]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)