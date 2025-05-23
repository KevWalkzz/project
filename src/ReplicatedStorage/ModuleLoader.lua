-- local ModuleLoader = {}
-- local CachedModules = {}

-- function ModuleLoader.Get(name: string)
-- 	return CachedModules[name]
-- end

-- function ModuleLoader._Init(scripts: { ModuleScript })
-- 	for _, modscript in scripts do
-- 		if not modscript:IsA("ModuleScript") then
-- 			continue
-- 		end
-- 		local mod = require(modscript)
-- 		CachedModules[modscript.Name] = mod
-- 	end
-- end

-- function ModuleLoader._Start()
-- 	for _, mod in CachedModules do
-- 		if mod.Start then
-- 			task.spawn(mod.Start)
-- 		end
-- 	end
-- end

-- shared.Get = ModuleLoader.Get

-- return ModuleLoader
