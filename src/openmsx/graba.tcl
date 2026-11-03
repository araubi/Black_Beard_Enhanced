set throttle off
after time $::env(REC_T0) "record start -audioonly -prefix $::env(OUT)/$::env(REC_NOMBRE)"
after time $::env(REC_T1) { record stop ; exit }
