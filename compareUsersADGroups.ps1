$user1 = ""
$user2 = ""

$user1 = Read-Host "First user to compare?"
$user2 = Read-Host "Other user to compare?"

$tmp = net user $user1 /domain
[System.Collections.ArrayList]$u1 = $tmp -split "\*"
$tmp = net user $user2 /domain
[System.Collections.ArrayList]$u2 = $tmp -split "\*"

for ($i = 0; $i -lt $u1.Count; $i++){
    if($u2.Contains($u1[$i])){
        $u2.remove($u1[$i])
        $u1.RemoveAt($i)
        $i--
    }
    if ($u1[$i] -match '^startup' -or $u1[$i] -match '^comment' -or $u1[$i] -match '^password' -or $u1[$i] -match 'name' -or $u1[$i] -match '^home' -or $u1[$i] -match '^last' -or $u1[$i] -match '^ +$') { 
        $u1.RemoveAt($i)
        $i--
    }
    if ($u2[$i] -match '^startup' -or $u2[$i] -match '^comment' -or $u2[$i] -match '^password' -or $u2[$i] -match 'name' -or $u2[$i] -match '^home' -or $u2[$i] -match '^last' -or $u2[$i] -match '^ +$') { 
        $u2.RemoveAt($i)
        $i--
    }
}


echo " "
echo " " 
echo "Groups '$user1' is in, that '$user2' is not"
echo " "
echo $u1
echo " "
echo " "
echo "=============================================================="
echo " "
echo " "
echo "Groups '$user2' is in, that '$user1' is not"
echo " "
echo $u2
pause
