defmodule Paperhubapi.Helpers do

  def convert_to_atommap(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), val}
  end

  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  def password_match(password, hash) do
    Bcrypt.verify_pass(password, hash)
  end

end
