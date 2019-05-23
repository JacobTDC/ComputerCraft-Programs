local utils = {};

function utils.clearTerm()
	term.clear();
	term.setCursorPos(1,1);
end

function utils.printColor(text, fgColor, bgColor)
	local currentFgColor = term.getTextColor();
	local currentBgColor = term.getBackgroundColor();

	if (not (fgColor == nil)) then
		if (type(fgColor) == "string") then
			term.setTextColor(colors[fgColor]);
		elseif (type(fgColor) == "number") then
			term.setTextColor(fgColor);
		else
			error("argument #2 expected string or number");
		end
	end
	if (not (bgColor == nil)) then
		if (type(bgColor) == "string") then
			term.setBackgroundColor(colors[bgColor]);
		elseif (type(bgColor) == "number") then
			term.setBackgroundColor(bgColor);
		else
			error("argument #3 expected string or number");
		end
	end

	write(text);

	if (not (fgColor == nil)) then
		term.setTextColor(currentFgColor);
	end
	if (not (bgColor == nil)) then
		term.setBackgroundColor(currentBgColor);
	end

	print();
end

function utils.printBlock(text, fgColor, bgColor)
	local width, height = term.getSize();
	local x, y = term.getCursorPos();
	term.setCursorPos(0, y);
	text = string.rep(" ", math.ceil((width - text:len()) / 2)) .. text .. string.rep(" ", math.floor((width - text:len()) / 2) + 1);
	utils.printColor(text, fgColor, bgColor);
end

function utils.printCenter(text, fgColor, bgColor)
	local width, height = term.getSize();
	local x, y = term.getCursorPos();
	term.setCursorPos(math.ceil((width / 2) - (text:len() / 2)), y);
	utils.printColor(text, fgColor, bgColor);
end

function utils.printCenterFromCursor(text, fgColor, bgColor)
	local width, height = term.getSize();
	local x, y = term.getCursorPos();
	term.setCursorPos(math.ceil(((width - x) / 2) - (text:len() / 2)) + x, y);
	utils.printColor(text, fgColor, bgColor);
end

return utils
