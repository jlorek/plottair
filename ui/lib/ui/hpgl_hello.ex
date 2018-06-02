defmodule Ui.HpglHello do
  def generate(points, pens, signature) do
    # some ranges from
    # https://github.com/tobiastoft/SymbolicDisarray
    # -- PLOTTER --
    # --  front  --
    # 0 - 602 - y - 10602 - ?
    # |
    # 170
    # |
    # x
    # |
    # 15370
    # |
    # ?

    init = ["IN", "SP1"]

    end_of_text = List.to_string([3])
    xPos = 15370
    yPos = 1863
    signature = case String.length(signature) do
      0 -> []
      _ -> ["PU#{xPos},#{yPos}", "SI0.2,0.2", "DI0,1", "LB#{signature}#{end_of_text}"]
    end
    
    # scale coordinate system to 0-100
    # and start from the middle
    scale = ["SC0,100,0,100", "PU50,50"]
    # try to not overlay the signature
    range = 0..99

    segment_size = Kernel.trunc(points / pens)
    random_positions = Enum.concat(
      Enum.map(1..pens, fn pen ->
        ["SP#{pen}"] ++ Enum.map(1..segment_size, fn _ -> "PD#{Enum.random(range)},#{Enum.random(range)}" end)
      end)
    )

    #random_positions = Enum.map(1..points, fn _i -> "PD#{Enum.random(range)},#{Enum.random(range)}" end)
    stop = ["SP0", "PG"]

    commands = init ++ signature ++ scale ++ random_positions ++ stop
    Enum.join(commands, ";\n")
  end
end