/obj/machinery/mass_driver
	name = "mass driver"
	desc = "The finest in spring-loaded piston toy technology, now launching prisoners into hyperspace near you."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "mass_driver"
	use_power = IDLE_POWER_USE
	idle_power_usage = IDLE_DRAW_MINIMAL
	active_power_usage = ACTIVE_DRAW_MEDIUM
	var/power = 1
	var/code = 1
	var/id = 1
	var/drive_range = 50	//this is mostly irrelevant since current mass drivers throw into space, but you could make a lower-range mass driver for interstation transport or something I guess.

/obj/machinery/mass_driver/Destroy()
	for(var/obj/machinery/computer/pod/control in GLOB.machines)
		if(control.id == id)
			control.connected = null
	return ..()

/obj/machinery/mass_driver/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[REF(port)][id]"

/obj/machinery/mass_driver/proc/drive(amount)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	use_power(500)
	var/O_limit
	var/atom/target = get_edge_target_turf(src, dir)
	for(var/atom/movable/O in loc)
		if(!O.anchored || ismecha(O))	//Mechs need their launch platforms.
			if(ismob(O) && !isliving(O))
				continue
			O_limit++
			if(O_limit >= 20)
				audible_message(span_notice("[src] lets out a screech, it doesn't seem to be able to handle the load."))
				break
			use_power(500)
			O.throw_at(target, drive_range * power, power)
	flick("mass_driver1", src)

/obj/machinery/mass_driver/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(machine_stat & (BROKEN|NOPOWER))
		return
	drive()
