-- EdgeTX TX16S widget by Mika Korhonen (Spider)
-- V 4.0, 2025/03/06

local app_name = "Battery"
local app_path = "/WIDGETS/Battery/"

local options = {
  { "BattSensor", SOURCE, 0 },
  { "Cells", VALUE, 3, 1, 12 },
  { "CellMax", VALUE, 420, 400, 435 },
  { "CellMin", VALUE, 360, 250, 380 },
  { "Alarm", BOOL, 1 },
  { "ShowStorage", BOOL, 0 }
}

local function fontSize(height, percentage)
  local txt_w, txt_h
  local fonts = {SMLSIZE, 0, MIDSIZE, DBLSIZE, XXLSIZE}
  local font = SMLSIZE
  for Count = 1, #fonts do
    txt_w, txt_h = lcd.sizeText("SIZE", fonts[Count] + WHITE + SHADOWED)
    if txt_h <= ((height / 100) * percentage) then
	  font = fonts[Count]
	end
  end
  return font
end

local function storagePos(widget)
  widget.storage = math.ceil(((widget.stepsEnd / 100) * ((380 - widget.options.CellMin) / ((widget.options.CellMax - widget.options.CellMin) / 100))))
end

local function batteryCells(widget)
  widget.BatMax = (widget.options.CellMax / 100) * widget.options.Cells
  widget.BatMin = (widget.options.CellMin / 100) * widget.options.Cells
  storagePos(widget)
end

local function update(widget, options)
  widget.options = options
  batteryCells(widget)
end

local function create(zone, options)
  local widget = {
    zone = zone,
    options = options,
    waitTime = getTime(),
    bt = 0,
    BatMax = 0,
	BatMin = 0,
	DARKBG = lcd.RGB(0x333333),
	picture = Bitmap.open(app_path.."battery.png"),
	stepsStart = 0,
	stepsEnd = 0,
	storage = 0,
	width = 0,
	height = 0,
	font1 = 0,
	font2 = 0
  }
  
  -- calculate picture size
  local ratio = 392 / 169;
  local maximizedToWidthW = widget.zone.w
  local maximizedToWidthH = widget.zone.w / ratio
  local maximizedToHeightW = widget.zone.h * ratio
  local maximizedToHeightH = widget.zone.h
  -- select correct picture size
  if maximizedToWidthH > widget.zone.h then
    widget.width = math.ceil(maximizedToHeightW)
    widget.height = math.ceil(maximizedToHeightH)
  else
    widget.width = math.ceil(maximizedToWidthW)
    widget.height = math.ceil(maximizedToWidthH)
  end
  -- font size
  widget.font1 = fontSize(widget.height, 45)
  widget.font2 = fontSize(widget.height, 68)
  -- resize picture
  widget.picture = Bitmap.resize(widget.picture, widget.width, widget.height)
  collectgarbage()
  -- calculate battery bar size
  widget.stepsStart = math.ceil(widget.width * 0.04) + math.ceil((widget.zone.w - widget.width) / 2)
  widget.stepsEnd   = math.ceil(widget.width * 0.88)
  storagePos(widget)
  -- fix (int) cell min/max to (float)
  batteryCells(widget)
  return widget
end

local function batteryWarning(widget)
  if widget.options.Alarm == 1 and widget.bt < widget.BatMin then
    if getTime() >= widget.waitTime then
      widget.waitTime = getTime() + 300
      playFile(app_path.."alarm.wav")
    end
  end
end

local function drawVoltageText(widget)
  if widget.options.Cells > 1 then
    lcd.drawText(widget.zone.w * 0.48, widget.height * 0.25, string.format("%.2fv", widget.bt), CENTER + VCENTER + widget.font1 + (widget.bt ~= 0 and YELLOW or COLOR_THEME_DISABLED + BLINK) + SHADOWED)
  end
  lcd.drawText(widget.zone.w * 0.48, widget.height * 0.72, string.format("%.2fv", widget.bt / widget.options.Cells), CENTER + VCENTER + widget.font2 + (widget.bt ~= 0 and YELLOW or COLOR_THEME_DISABLED + BLINK) + SHADOWED)
end

local function drawBatteryBar(widget, step)
  lcd.drawFilledRectangle(widget.stepsStart, 0, step,  widget.height, GREEN)
end

local function background(widget)
  widget.bt = getValue(widget.options.BattSensor)
  if widget.bt ~= 0 then
    batteryWarning(widget)
  end
end

local function refresh(widget, event, touchState)
  -- draw battery background
  lcd.drawFilledRectangle(widget.stepsStart, 0, widget.stepsEnd, widget.height, widget.DARKBG)
  widget.bt = getValue(widget.options.BattSensor)
  if widget.bt ~= 0 then
	-- calculate and draw battery bar
    local step = math.ceil(((widget.stepsEnd / 100) * ((widget.bt - widget.BatMin) / ((widget.BatMax - widget.BatMin) / 100))))
    if step >= 0 and step <= widget.stepsEnd then
      drawBatteryBar(widget, step)
    elseif step > widget.stepsEnd then
      drawBatteryBar(widget, widget.stepsEnd)
    else
	  batteryWarning(widget)
	end
    -- draw storage bar
    if widget.options.ShowStorage == 1 then
      lcd.drawFilledRectangle(widget.stepsStart, math.ceil(widget.height * 0.93), widget.storage, widget.height - math.ceil(widget.height * 0.93), RED)
    end
  end
  -- draw battery png and text
  lcd.drawBitmap(widget.picture, math.ceil((widget.zone.w - widget.width) / 2), 0)
  drawVoltageText(widget)
end

return {
  name = app_name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}