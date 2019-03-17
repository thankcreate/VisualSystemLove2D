-----------------------------------------------------------------------------------------------
-- Image Analyzer
-- TronTron 2019/03/16
-----------------------------------------------------------------------------------------------
local bkgData = love.image.newImageData(globalScenePath .. "images/bkg.png")
local bkg = love.graphics.newImage(bkgData) 

bkgWidth = bkg:getWidth()
bkgHeight = bkg:getHeight()

bkgColor = {}
bkgColorWidth = bkgWidth
bkgColorHeight = bkgHeight
for i = 1, bkgColorWidth do
    bkgColor[i] = {}
    for j = 1, bkgColorHeight  do
        local r, g, b = bkgData:getPixel(i - 1, j - 1)
        bkgColor[i][j] = color(r, g, b, 1)
    end
end

-- bkgColorAv = {} 

-- bkgColorAvWidth = (width) / step
-- bkgColorAvHeight = (height) / step

-- eachX = math.floor(bkgColorWidth / bkgColorAvWidth)
-- eachY = math.floor(bkgColorAvHeight / bkgColorAvWidth)

-- for i = 1, bkgColorAvWidth do
--     bkgColorAv[i] = {}
--     for j = 1, bkgColorAvHeight  do
--         local r, g, b = bkgData:getPixel(i - 1, j - 1)
--         bkgColorAv[i][j] = color(r, g, b, 1)
--     end
-- end

