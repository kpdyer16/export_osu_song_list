@echo off
title Osu Song List Uploader
setlocal enabledelayedexpansion
set oldOsuPath1=C:\Program Files\osu^^!\
set oldOsuPath2=C:\Program Files(x86)\osu^^!\
set osupath=C:\Users\%username%\AppData\Local\osu^^!\

echo Determining osu^^! path..
if not exist !osupath! (
    if not exist !oldOsuPath1! (
        if not exist !oldOsuPath2! (
            echo Oops.. Can't find the osu folder.
            set /p osupath=Please paste the path here^> 
        ) else (
            set osupath=!oldOsuPath2!
        )
    ) else (
        set osupath=!oldOsuPath1!
    )
)
echo Your osu^^! path is !osupath! && echo.

:: by now osupath is set to the correct path
echo Creating osu_song_list_temp.txt.
dir !osupath!\Songs /B /AD-R > osu_song_list_temp.txt

echo Generating links
:song_list_check
if not exist osu_song_list.txt (
    for /f "tokens=1*" %%i in ('findstr /b /r [1-9] osu_song_list_temp.txt') do (
        echo https://osu.ppy.sh/beatmapsets/%%i %%j >> osu_song_list.txt
    )
    echo osu_song_list.txt complete && echo.
) else (
    echo osu_song_list.txt already exists.
    set /p response="Would you like to overwrite it? (y/n) " 
    if !response!==y (
        del osu_song_list.txt
        goto :song_list_check
    ) else (
        goto :finished
    )
)

echo beatmaps without proper ID's will go into osu_song_list_reject.txt (this occurs with user-created beatmaps and beatmaps downloaded in an alternate site)
:song_list_reject_check
if not exist osu_song_list_reject.txt (
    for /f "tokens=1*" %%i in ('findstr /b /r /v [1-9] osu_song_list_temp.txt') do (
        echo %%i %%j >> osu_song_list_reject.txt
    ) 
    echo osu_song_list_reject.txt complete
) else (
    echo osu_song_list_reject.txt already exists.
    set /p response="Would you like to overwrite it? (y/n) "
    if !response!==y (
        del osu_song_list_reject.txt
        goto :song_list_reject_check
    ) else (
        goto :finished
    )
)

echo All done!
:finished
echo Alright good bye
del osu_song_list_temp.txt
pause


:: convert beatmap id into proper link. still need to fix this for beatmaps 
:: not prefixed with an id (user-made beatmaps)
:: for /f %i in (osu_song_list.txt) do echo https://osu.ppy.sh/beatmapsets/%i


:: print all songs with id's
:: findstr /b /r [1-9] osu_song_list.txt
:: print all songs without id's
:: findstr /b /r /v [1-9] osu_song_list.txt
:: if exist songlist echo A directory or file named songlist already exists. This script may overwrite the contents of songlist. && set /p answer=Would you like to continue? (Y/N)