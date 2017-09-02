defmodule StreamerTest do
  use ExUnit.Case
  doctest Streamer

  test "find index file inside a given directory" do
    assert Streamer.find_index_file("test/fixtures") ==
    "9af0270acb795f9dcafb5c51b1907628.m3u8"
  end
end
