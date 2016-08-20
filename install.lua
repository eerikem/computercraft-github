-- Easy Installer for computercraft-github by Eric Wieser
-- https://github.com/eric-wieser/computercraft-github

local REPO_BASE = 'https://raw.githubusercontent.com/eric-wieser/computercraft-github/master/'

local FILES = {
  'apis/dkjson',
  'apis/github',
  'programs/github'
}

local function request(url_path)
  local request = http.get(REPO_BASE..url_path)
  status = request.getResponseCode()
  response = request.readAll()
  request.close()
  return status, response
end

local function makeFile(file_path, data)
 local file = fs.open('github.rom/'..file_path,'w')
 file.write(data)
 file.close()
end

for key, path in pairs(FILES) do
  local try = 0
  local status, response = request(path)
  while status ~= 200 and try <= 3 do
    status, response = request(path)
    try = try + 1
  end
  makeFile(path, response)
end

f = fs.open('github', 'w')
f.write("dofile('github.rom/programs/github')")
f.close()
print("github by Eric Wieser installed!")
print("Usage: github clone <user>/<repo name> [destination folder]")