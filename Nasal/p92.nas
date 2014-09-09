var magnetoL = props.globals.getNode("/controls/engines/engine/magnetoL",1).getBoolValue();
var magnetoR = props.globals.getNode("/controls/engines/engine/magnetoR",1).getBoolValue();
var magnetos = props.globals.getNode("/controls/engines/engine/magnetos",1).getBoolValue();
var cranking = props.globals.getNode("/engines/engine/cranking",1).getBoolValue();
var running = props.globals.getNode("/engines/engine/running",1).getBoolValue();
var starter = props.globals.getNode("/controls/engines/engine/starter",1).getBoolValue();
var starter_serviceable = 0;
var cranking_serviceable = 0;
var engine_serviceable = 0;

setlistener("/sim/signals/fdm-initialized", func{
  setprop("/sim/sound/volume",1.0);
  settimer(update_system, 1);
  setprop("/controls/gear/brake-parking",1);
  setprop("/controls/gear/brake-parking-pos",1);
  setprop("/instrumentation/doors/crew/position-norm",1);
  setprop("/consumables/fuel/tank[1]/selected",1);
});

setlistener("/sim/current-view/view-number", func(vw) {
    var nm = vw.getValue();
    setprop("sim/model/sound/volume", 1.0);
    if(nm == 0 or nm == 7)setprop("sim/model/sound/volume", 0.5);
},1,0);

setlistener("/engines/engine/running", func(running) {
    var running = running.getBoolValue();
    if(running){ 
      interpolate("/engines/engine/oil-pressure-psi", 6, 0.9);
    }else{
      interpolate("/engines/engine/oil-pressure-psi", 0, 0.9);
    }
});

##############################################
################# ANIMATION  #################
################ INTERPOLATE  ################
##############################################

setlistener("/controls/engines/engine/magnetoguardL", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/magnetoguardL-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/magnetoguardL-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/magnetoguardR", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/magnetoguardR-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/magnetoguardR-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/magnetoL", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/magnetoL-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/magnetoL-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/magnetoR", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/magnetoR-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/magnetoR-pos", 0, 0.25);
  }
});

setlistener("/controls/gear/brake-parking", func(v) {
  if(v.getValue()){
    interpolate("/controls/gear/brake-parking-pos", 1, 0.25);
  }else{
    interpolate("/controls/gear/brake-parking-pos", 0, 0.25);
  }
});

setlistener("/consumables/fuel/tank/selected", func(v) {
  if(v.getValue()){
    interpolate("/consumables/fuel/tank/selected-pos", 1, 0.25);
  }else{
    interpolate("/consumables/fuel/tank/selected-pos", 0, 0.25);
  }
});

setlistener("/consumables/fuel/tank[1]/selected", func(v) {
  if(v.getValue()){
    interpolate("/consumables/fuel/tank[1]/selected-pos", 1, 0.25);
  }else{
    interpolate("/consumables/fuel/tank[1]/selected-pos", 0, 0.25);
  }
});

setlistener("/controls/cabin/heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/cabin/heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/cabin/heat-pos", 0, 0.25);
  }
});

setlistener("/controls/electric/key", func(v) {
    interpolate("/controls/electric/key-pos", v.getValue(), 0.25);
});

setlistener("/controls/lighting/beacon", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/beacon-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/beacon-pos", 0, 0.25);
  }
});

setlistener("/controls/switches/transponder", func(v) {
  if(v.getValue()){
    interpolate("/controls/switches/transponder-pos", 1, 0.25);
  }else{
    interpolate("/controls/switches/transponder-pos", 0, 0.25);
  }
});

setlistener("/controls/flight/flaps-anim", func(v) {
    interpolate("/controls/flight/flaps-anim-pos", v.getValue(), 0.25);
});

setlistener("/instrumentation/comm/ptt", func(v) {
  if(v.getValue()){
    interpolate("/instrumentation/comm/ptt-pos", 1, 0.25);
  }else{
    interpolate("/instrumentation/comm/ptt-pos", 0, 0.25);
  }
});

##############################################
############### CONVERT UNIT #################
##############################################

setlistener("/instrumentation/airspeed-indicator/indicated-speed-kt", func(asi) {
    var speed = asi.getValue();
    speed = speed * 1.852;
    setprop("/instrumentation/airspeed-indicator/indicated-speed-kmh", speed);
});

setlistener("/engines/engine/oil-temperature-degf", func(degf) {
    var degf = degf.getValue();
    var degc = (degf - 32) * (5 / 9);
    setprop("/engines/engine/oil-temperature-degc", degc);
});

##############################################
######### AUTOSTART / AUTOSHUTDOWN ###########
##############################################

setlistener("/sim/model/start-idling", func(idle){
    var run= idle.getBoolValue();
    if(run){
    Startup();
    }else{
    Shutdown();
    }
},0,0);

var Startup = func {
  setprop("/controls/electric/key",1);
  setprop("/controls/engines/engine/magnetoL",1);
  setprop("/controls/engines/engine/magnetoR",1);
  setprop("/controls/engines/engine/magnetos",3);
  setprop("/engines/engine/rpm",2700);
  setprop("/engines/engine/running",1);
  setprop("/controls/gear/brake-parking",0);
  setprop("/instrumentation/doors/crew/position-norm",0);
}

var Shutdown = func {
  setprop("/controls/electric/key",0);
  setprop("/controls/engines/engine/magnetoL",0);
  setprop("/controls/engines/engine/magnetoR",0);
  setprop("/controls/engines/engine/magnetos",0);
  setprop("/engines/engine/rpm",0);
  setprop("/engines/engine/running",0);
  setprop("/controls/gear/brake-parking",1);
  setprop("/instrumentation/doors/crew/position-norm",1);
}

###############################################
###############################################
###############################################

var update_system = func{
  var magnetoL = props.globals.getNode("/controls/engines/engine/magnetoL",1).getBoolValue();
  var magnetoR = props.globals.getNode("/controls/engines/engine/magnetoR",1).getBoolValue();
  var battery_switch = props.globals.getNode("/controls/electric/battery-switch",1).getBoolValue();
  var magneto = 0;
  
  if (battery_switch and magnetoL and magnetoR){
    magneto = 3;
  }elsif (battery_switch and (magnetoL or magnetoR)){
    magneto = 1;
  }elsif (battery_switch and !magnetoL and !magnetoR){
    magneto = 0;
  }
  setprop("/controls/engines/engine/magnetos",magneto);

  settimer(update_system, 0);
}
