term.clear();
term.setCursorPos(1,1);

fs.delete("/utils");
shell.run("wget https://raw.githubusercontent.com/JacobTDC/ComputerCraft-Programs/master/utils/terminal.lua /termutils");

local utils = require("/termutils");

term.setBackgroundColor(colors.red);
utils.clearKeepColors();
local width, height = term.getSize();
term.setCursorPos(0, math.ceil(height / 2));
utils.printCenter("RednetTracker Installer");
sleep(3);

utils.clearTerm();
shell.run("pastebin get GDxTa0Q8 /rednettrack");

local function yn(query, title, default)
    utils.clearKeepColors();
    utils.printBlock(title, "white", "red");
    print(query);

    local currentAns;

    if (default == true) then
        write("[y/n]: yes");
        currentAns = true;
    elseif (default == false) then
        write("[y/n]: no");
        currentAns = false;
    else
        write("[y/n]: ");
        currentAns = nil;
    end

    term.setCursorBlink(true);
    while (true) do
        local event, key, isHeld = os.pullEvent("key");
        local key = keys.getName(key);
        local x, y = term.getCursorPos();
        if (key == "y") then
            currentAns = true;
            term.setCursorPos(8, y);
            write("yes");
        elseif (key == "n") then
            currentAns = false;
            term.setCursorPos(8, y);
            write("no ");
            term.setCursorPos(10, y);
        elseif (key == "backspace") then
            currentAns = nil;
            term.setCursorPos(8, y);
            write("   ");
            term.setCursorPos(8, y);
        elseif (key == "enter" and currentAns ~= nil) then
            term.setCursorBlink(false);
            return currentAns
        end
    end
end

local function ask(query, title, prompt, sub, required, autocomplete)
    local data = "";
    while (data == "") do
        utils.clearKeepColors();
        utils.printBlock(title, "white", "red");
        print(query);
        write(prompt);
        data = read(nil, nil, autocomplete);
        if (not required) then
            return data
        end
    end
    return data
end

if(not yn("RednetTracket has been installed as /rednettrack. Would you like to continue the setup?", "Setup Options", true)) then
	utils.clearTerm();
	error("Setup canceled.");
end

local runOnStartup = yn("Should RednetTracker run on startup?", "Setup Options", true);
--settings.set("shell.allow_disk_startup", yn("Should startup disks run on startup?", "Setup Options", true));
local startupScript = "/rednettrack";
if (runOnStartup and yn("Would you like to set a custom startup script?", "Setup Options", false)) then
	local tempStartupScript = ask("Enter a shell script, or leave blank for default.\nDefault startup script: " .. startupScript, "Startup Script", "> ", nil, false, shell.complete);
	if (tempStartupScript ~= "") then startupScript = tempStartupScript end
end
settings.set("rednettrack.save", yn("Should RednetTracker save all received data?", "Setup Options", true));
local fileComplete = function(partial) return fs.complete(partial,  "", false, false) end
local saveLocation = "/rednettrack.log";
if (settings.get("rednettrack.save") and yn("Would you like to set a custom save location?", "Setup Options", false)) then
	local tempSaveLocation = ask("Enter a location, or leave blank for default.\nDefault save location: " .. saveLocation, "Save Location", "> ", nil, false, fileComplete);
	if (tempSaveLocation ~= "") then saveLocation = shell.resolve(tempSaveLocation) end
end
settings.set("rednettrack.saveLocation", saveLocation);
settings.save(".settings");

utils.clearTerm();

if (runOnStartup) then
	fs.delete("startup");
	local startupFile = fs.open("/startup", "w");
	startupFile.write("shell.run(\"" .. startupScript .. "\")");
	startupFile.close();
end

utils.clearTerm();
term.setBackgroundColor(colors.red);
utils.clearKeepColors();
local width, height = term.getSize();
term.setCursorPos(0, math.ceil(height / 2) - 1);
utils.printCenter("RednetTracker Installed");
utils.printCenter("The system will restart");
sleep(3);

os.reboot();