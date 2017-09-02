defmodule Streamer do
  @moduledoc """
  Documentation for Streamer.
  """
  defp get_m3u8_files(path) do
    # TODO: need a way to specify a custom file extension
    files = Path.join(path, "*.m3u8")
    Path.wildcard(files)
  end

  defp is_index_file?(path) do
    File.open! path, fn(pid) ->
      IO.read(pid, 25) == "#EXTM3U\n#EXT-X-STREAM-INF"
    end
  end

  def find_index_file(path) do
    if file = Enum.find get_m3u8_files(path), &is_index_file?(&1) do
      Path.basename file
    end
  end
end
