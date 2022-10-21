
if exist Odix_ProPlus (
	  
	  git config --global --add safe.directory D:/Odix_ProPlus
	  cd D:\Odix_ProPlus
     git Fatch https://github.com/kh1ld/Odix_ProPlus_Set.git
) else (
    git clone https://github.com/kh1ld/Odix_ProPlus_Set.git Odix_ProPlus
)
pause

