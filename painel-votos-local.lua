-- Painel local de votos - versao 5
-- Apenas simula contagens; nao altera os apoios oficiais do servidor.
local Players = game:GetService("Players")
local Input = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

for _,name in ipairs({"PainelVotosBrasil","SimuladorVotosBrasil","PainelVotosBrasilV4"}) do
    local old = pg:FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "PainelVotosBrasilV4"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = pg

local function create(class, parent, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function round(obj, n)
    create("UICorner",obj,{CornerRadius=UDim.new(0,n)})
end
local white=Color3.fromRGB(255,255,255)
local green=Color3.fromRGB(30,180,105)
local frame=create("Frame",gui,{
    Name="Janela",Size=UDim2.fromOffset(340,365),
    Position=UDim2.new(.5,-170,.5,-182),
    BackgroundColor3=Color3.fromRGB(17,24,39),
    BorderSizePixel=0,ZIndex=20,Active=true
})
round(frame,14)
create("UIStroke",frame,{Color=green,Thickness=2})
local header=create("Frame",frame,{
    Name="Barra",Size=UDim2.new(1,0,0,52),
    BackgroundColor3=Color3.fromRGB(25,42,48),
    BorderSizePixel=0,ZIndex=21,Active=true
})
round(header,12)
local function label(parent, txt, pos, size, fontsize, color, z)
    return create("TextLabel",parent,{
        Text=txt,TextColor3=color or white,TextSize=fontsize,
        Font=Enum.Font.GothamBold,BackgroundTransparency=1,
        Position=pos,Size=size,ZIndex=z or 30,
        Visible=true,TextTransparency=0,TextStrokeTransparency=1,
        TextWrapped=true
    })
end
local function button(txt,pos,size,color)
    local obj=create("TextButton",frame,{
        Text=txt,TextColor3=white,TextSize=15,
        Font=Enum.Font.GothamBold,TextTransparency=0,
        BackgroundColor3=color,BorderSizePixel=0,
        Position=pos,Size=size,ZIndex=31,AutoButtonColor=true
    })
    round(obj,8)
    return obj
end
label(frame,"PAINEL DE VOTOS",UDim2.fromOffset(12,7),UDim2.fromOffset(215,38),17,white,40)
local close=button("X",UDim2.new(1,-38,0,11),UDim2.fromOffset(28,30),Color3.fromRGB(180,55,65))
local min=button("-",UDim2.new(1,-73,0,11),UDim2.fromOffset(28,30),Color3.fromRGB(67,78,87))
local count=label(frame,"VOTOS SIMULADOS: 0",UDim2.fromOffset(10,66),UDim2.fromOffset(320,50),19,green,40)
local field=create("TextBox",frame,{
    Name="Quantidade",Text="",PlaceholderText="Digite a quantidade de votos",
    TextColor3=white,PlaceholderColor3=Color3.fromRGB(180,180,180),
    TextSize=15,Font=Enum.Font.Gotham,TextTransparency=0,
    BackgroundColor3=Color3.fromRGB(38,51,64),
    Position=UDim2.fromOffset(20,123),Size=UDim2.fromOffset(300,43),
    ZIndex=40,ClearTextOnFocus=false
})
round(field,8)
local add=button("ADICIONAR VOTOS",UDim2.fromOffset(20,178),UDim2.fromOffset(300,43),green)
local npc=button("SIMULAR NPC +100",UDim2.fromOffset(20,232),UDim2.fromOffset(300,40),Color3.fromRGB(44,111,187))
local reset=button("ZERAR CONTADOR",UDim2.fromOffset(20,283),UDim2.fromOffset(300,40),Color3.fromRGB(168,65,65))
label(frame,"Somente visual: nao altera o apoio do jogo.",UDim2.fromOffset(20,329),UDim2.fromOffset(300,24),12,white,40)
local votes=0
add.MouseButton1Click:Connect(function()
    local n=tonumber(field.Text)
    if not n or n~=math.floor(n) or n<1 or n>1000000000 then
        field.Text=""
        field.PlaceholderText="Numero inteiro de 1 a 1 bilhao"
        return
    end
    votes=votes+n
    count.Text="VOTOS SIMULADOS: "..tostring(votes)
    field.Text=""
end)
npc.MouseButton1Click:Connect(function()
    votes=votes+100
    count.Text="VOTOS SIMULADOS: "..tostring(votes)
end)
reset.MouseButton1Click:Connect(function()
    votes=0
    count.Text="VOTOS SIMULADOS: 0"
end)
close.MouseButton1Click:Connect(function() frame.Visible=false end)
local collapsed=false
min.MouseButton1Click:Connect(function()
    collapsed=not collapsed
    frame.Size=collapsed and UDim2.fromOffset(340,52) or UDim2.fromOffset(340,365)
    for _,obj in ipairs({count,field,add,npc,reset}) do obj.Visible=not collapsed end
    min.Text=collapsed and "+" or "-"
end)
local drag=false
local start,initial
header.InputBegan:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then
        drag=true start=event.Position initial=frame.Position
    end
end)
Input.InputEnded:Connect(function(event)
    if event.UserInputType==Enum.UserInputType.MouseButton1 or event.UserInputType==Enum.UserInputType.Touch then drag=false end
end)
Input.InputChanged:Connect(function(event)
    if drag and (event.UserInputType==Enum.UserInputType.MouseMovement or event.UserInputType==Enum.UserInputType.Touch) then
        local d=event.Position-start
        frame.Position=UDim2.new(initial.X.Scale,initial.X.Offset+d.X,initial.Y.Scale,initial.Y.Offset+d.Y)
    end
end)
Input.InputBegan:Connect(function(event,used)
    if not used and event.KeyCode==Enum.KeyCode.PageUp then
        frame.Visible=not frame.Visible
    end
end)
