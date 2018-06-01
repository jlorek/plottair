defmodule Ui.HpglHello do
  def generate(points, _pens, signature) do
    # some ranges from
    # https://github.com/tobiastoft/SymbolicDisarray
    # -- PLOTTER --
    # --  front  --
    # 602 - y - 10602
    # 170
    # |
    # x
    # |
    # 15370

    init = ["IN", "SP1"]

    xPos = 10602
    yPos = 1863
    signature = case String.length(signature) do
      0 -> []
      _ -> ["PU#{xPos},#{yPos}", "SI0.2,0.2", "DI0,1", "DT.", "LB#{signature}."]
    end
    
    scale = ["SC0,100,0,100", "PU50,50"]
    range = 0..100
    random_positions =  Enum.map(1..points, fn _i -> "PD#{Enum.random(range)},#{Enum.random(range)}" end)
    stop = ["SP0", "PG"]

    commands = init ++ signature ++ scale ++ random_positions ++ stop
    Enum.join(commands, ";\n")
  end
end