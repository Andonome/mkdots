#/bin/bash
getvol(){
	 mpcvol="$(mpc volume | cut -d':' -f 2 | sed s/%//)"
}
[ -z mpcvol ] && getvol

# [ -e /tmp/mpcvol ] && mpcvol="$(cat /tmp/mpcvol)" || getvol

if [[ "$(mpc|grep playing -c)" -eq 0 ]]
then
	getvol # && pintf $mpcvol > /tmp/mpcvol
	mpc volume 0
	mpc play &>/dev/null
	for i in `seq 1 $mpcvol`
	do 
		sleep 0.05
		mpc volume +1 &>/dev/null
	done

else
	getvol
	for i in `seq 1 $mpcvol`
	do
		sleep 0.05
		mpc volume -1 &>/dev/null
	done
	mpc pause &>/dev/null
	mpc volume $mpcvol
fi

