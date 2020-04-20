# !/bin/bash
vkpassFolder="/Users/Anonym0uz/Desktop/Tweaks/vkpass/"
dylibPath="$vkpassFolder./.theos/obj/debug"
vkFolder="/Users/Anonym0uz/Desktop/No-JB/vk"
vkFilesFolder="$vkFolder/Files"
prefsFolder="/Users/Anonym0uz/Desktop/Tweaks/vkpass/vkpassprefs/Resources"

echo "[->] Make clean..."
make clean
echo "[->] Clean all paths..."
rm -rf ./.theos
echo "[->] Make tweak package..."
make package
echo "[->] Search .dylib in $dylibPath and .plist's from $prefsFolder..."
cp -R "$dylibPath/VKPass.dylib" "$vkFilesFolder"
cp -R "$prefsFolder/en.lproj" "$vkFilesFolder"
cp -R "$prefsFolder/ru.lproj" "$vkFilesFolder"
echo "[->] Run sh script in VK folder..."
sh "$vkFolder/script.sh"