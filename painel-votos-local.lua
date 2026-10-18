-- Simulador local de votos para Roblox Studio. Nao altera votacoes reais.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local parent=player:WaitForChild("PlayerGui")
local old=parent:FindFirstChild("SimuladorVotosBrasil")
if old then old:Destroy() end
local function make(kind,properties,container)
    local instance=Instance.new(kind)
    for k,v in pairs(properties) do instance[k]=v end
    instance.Parent=container
    return instance
end
local function rounded(object)
    make("UICorner",{CornerRadius=UDim.new(0,10)},object)
end
local white=Color3.fromRGB(245,248,250)
local green=Color3.fromRGB(38,185,105)
local gui=make("ScreenGui",{Name="SimuladorVotosBrasil",ResetOnSpawn=false},parent)
local frame=make("Frame",{
    Size=UDim2.fromOffset(340,340),Position=UDim2.new(.5,-170,.5,-170),
    BackgroundColor3=Color3.fromRGB(18,26,39),BorderSizePixel=0,Active=true
},gui)
rounded(frame)
make("UIStroke",{Color=green,Thickness=1.5},frame)
local top=make("Frame",{Size=UDim2.new(1,0,0,55),BackgroundColor3=Color3.fromRGB(26,49,50),BorderSizePixel=0,Active=true},frame)
rounded(top)
make("TextLabel",{Text="BRASIL | VOTACAO",Font=Enum.Font.GothamBold,TextSize=17,TextColor=white,TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-100,1,0)},top)
local close=make("TextButton",{Text="X",Font=Enum.Font.GothamBold,TextColor=white,TextSize=15,Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-39,0,12),BackgroundColor3=Color3.fromRGB(184,55,65)},top)
rounded(close)
local minimize=make("TextButton",{Text="-",Font=Enum.Font.GothamBold,TextColor=white,TextSize=19,Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-77,0,12),BackgroundColor3=Color3.fromRGB(58,73,82)},top)
rounded(minimize)
local body=make("Frame",{BackgroundTransparency=1,Position=UDim2.fromOffset(0,55),Size=UDim2.new(1,0,1,-55)},frame)
local count=make("TextLabel",{Text="SIM: 0     NAO: 0",TextColor3=green,Font=Enum.Font.GothamBold,TextSize=19,BackgroundTransparency=1,Position=UDim2.fromOffset(15,12),Size=UDim2.new(1,-30,0,50)},body)
local amount=make("TextBox",{Text="",PlaceholderText="Quantidade de votos",ClearTextOnFocus=false,TextColor3=white,PlaceholderColor3=Color3.fromRGB(155,165,177),Font=Enum.Font.Gotham,TextSize=15,BackgroundColor3=Color3.fromRGB(38,50,65),Position=UDim2.fromOffset(18,70),Size=UDim2.new(1,-36,0,42)},body)
rounded(amount)
local yes=make("TextButton",{Text="ADICIONAR SIM",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=white,BackgroundColor3=green,Position=UDim2.fromOffset(18,124),Size=UDim2.new(.5,-23,0,43)},body)
rounded(yes)
local no=make("TextButton",{Text="ADICIONAR NAO",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=white,BackgroundColor3=Color3.fromRGB(170,66,67),Position=UDim2.new(.5,5,0,124),Size=UDim2.new(.5,-23,0,43)},body)
rounded(no)
local reset=make("TextButton",{Text="ZERAR CONTADORES",Font=Enum.Font.GothamBold,TextSize=14,TextColor3=white,BackgroundColor3=Color3.fromRGB(72,86,104),Position=UDim2.fromOffset(18,180),Size=UDim2.new(1,-36,0,40)},body)
rounded(reset)
local note=make("TextLabel",{Text="Somente simulacao local | PgUp abre/fecha",TextColor3=Color3.fromRGB(171,185,195),Font=Enum.Font.Gotham,TextSize=12,TextWrapped=true,BackgroundTransparency=1,Position=UDim2.fromOffset(16,230),Size=UDim2.new(1,-32,0,35)},body)
local sim,nao=0,0
local function display() count.Text="SIM: "..sim.."     NAO: "..nao end
local function addVote(side)
    local number=tonumber(amount.Text)
    if not number or number~=math.floor(number) or number<1 or number>1000000000 then
        note.Text="Digite um numero inteiro entre 1 e 1 bilhao."
        return
    end
    if side=="sim" then sim+=number else nao+=number end
    display()
    amount.Text=""
    note.Text="Atualizado apenas nesta interface local."
end
yes.MouseButton1Click:Connect(function() addVote("sim") end)
no.MouseButton1Click:Connect(function() addVote("nao") end)
reset.MouseButton1Click:Connect(function() sim=0 nao=0 display() note.Text="Contadores zerados." end)
close.MouseButton1Click:Connect(function() frame.Visible=false end)
local collapsed=false
minimize.MouseButton1Click:Connect(function()
    collapsed=not collapsed
    body.Visible=not collapsed
    frame.Size=collapsed and UDim2.fromOffset(340,55) or UDim2.fromOffset(340,340)
    minimize.Text=collapsed and "+" or "-"
end)
local dragging,startPoint,startPos=false,nil,nil
top.InputBegan:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then
        dragging=true startPoint=event.Position startPos=frame.Position
    end
end)
UIS.InputEnded:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UIS.InputChanged:Connect(function(event)
    if dragging and (event.UserInputType==Enum.UserInputType.MouseMovement or event.UserInputType==Enum.UserInputType.Touch) then
        local delta=event.Position-startPoint
        frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
UIS.InputBegan:Connect(function(event,processed)
    if not processed and event.KeyCode==Enum.KeyCode.PageUp then
        frame.Visible=not frame.Visible
    end
end)
