defmodule StreamerTest do
  use ExUnit.Case, async: true
  doctest Streamer

  # alias Streamer.m3u8

  @index_file "test/fixtures/9af0270acb795f9dcafb5c51b1907628.m3u8"
  @first_m3u8_file "test/fixtures/8bda35243c7c0a7fc69ebe1383c6464c.m3u8"

  test "find index file inside a given directory" do
    assert Streamer.find_index_file("test/fixtures") == @index_file
  end

  test "return nil for nonexistent directory" do
    assert Streamer.find_index_file("test/mixtures") == nil
  end

  test "extracts m3u8 files from a given index file" do
    m3u8s = Streamer.extract_m3u8_files(@index_file)
    assert Enum.at(m3u8s, 0) == Streamer.m3u8(program_id: 1, path: @first_m3u8_file, bandwidth: 110000)

    # should find all m3u8 files inside an index file
    assert length(m3u8s) == 5
  end
end
