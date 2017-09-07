defmodule Streamer do
  @moduledoc """
  Documentation for Streamer.
  """

  require Record
  Record.defrecord :m3u8, [program_id: nil, path: nil, bandwidth: nil]

  defp get_m3u8_files(directory) do
    # TODO: need a way to specify a custom file extension
    files = Path.join(directory, "*.m3u8")
    Path.wildcard(files)
  end

  defp is_index_file?(path) do
    # TODO: need a way to provide a custom string to match index file
    File.open! path, fn(pid) ->
      IO.read(pid, 25) == "#EXTM3U\n#EXT-X-STREAM-INF"
    end
  end

  defp do_extract_m3u_file(pid, dir, acc) do
    case IO.read(pid, :line) do
      :eof -> Enum.reverse(acc)
      stream_inf ->
        path = IO.read(pid, :line)
        do_extract_m3u_file(pid, dir, stream_inf, path, acc)
    end
  end

  defp do_extract_m3u_file(pid, dir, stream_inf, path, acc) do
    <<"#EXT-X-STREAM-INF:PROGRAM-ID=", id , ",BANDWIDTH=", bandw :: binary>> = stream_inf

    {bandwidth, _} = Integer.parse(bandw |> String.strip)

    record = m3u8(
      program_id: id - ?0,
      path: Path.join(dir, path |> String.strip),
      bandwidth: bandwidth
    )
    do_extract_m3u_file(pid, dir, [record | acc])
  end

  def extract_m3u8_files(index_file) do
    File.open! index_file, fn(pid) ->
      IO.read(pid, :line)
      do_extract_m3u_file(pid, Path.dirname(index_file), [])
    end
  end

  @doc """
  Finds an index m3u8 file inside a given direcory.

  ## Examples
    iex> Streamer.find_index_file("test/fixtures")
    "test/fixtures/9af0270acb795f9dcafb5c51b1907628.m3u8"
  """
  def find_index_file(directory) do
    if file = Enum.find get_m3u8_files(directory), &is_index_file?(&1) do
      file
    end
  end

end