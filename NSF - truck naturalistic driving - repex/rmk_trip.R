pacman::p_load(data.table, lubridate, geosphere, magrittr)
setDTthreads(parallel::detectCores())
d = fread("data/20190626_ping_with_weather.csv")


rmk_trip = function(data = d, sep_time = 30, datapath = "data/"){
  # 01. clean the original data
  ping_df = d %>%
    .[,`:=`(driver1 = gsub("\"", "", driver1),
            DATIME  = ymd_hms(DATIME))] %>%
    setkey(driver1, DATIME) %>%
    .[, .(ping_id, trip_id, driver = driver1, ping_time = DATIME,
          lon = LONGITUDE, lat = LATITUDE, speed = SPEED,
          PRECIP_INTENSITY, PRECIP_PROBABILITY, WIND_SPEED,
          VISIBILITY, SUNRISE_TIME, SUNSET_TIME)]

  # 02. trip_df
  trip_df = ping_df %>%
    .[, .SD[c(1, .N)], by = c("driver", "trip_id")] %>%
    .[,time_type := rep(c("start_time", "end_time0"), .N/2)] %>%
    .[,time_type := factor(time_type, levels = c("start_time", "end_time0"))] %>%
    dcast(driver + trip_id ~ time_type, value.var = "ping_time") %>%
    .[,trip_time := as.integer(difftime(end_time0, start_time, units = "mins"))] %>%
    .[,trip_units := ceiling(trip_time/30)] %>%
    .[rep(seq(.N), trip_units), !c("trip_time", "trip_units")] %>%
    .[,add1 := 0:(.N-1), by = c("driver", "trip_id")] %>%
    .[,start_time := start_time[1] + add1*30*60, .(driver, trip_id)] %>%
    .[,end_time := shift(start_time, type = "lead"), .(driver, trip_id)] %>%
    .[,end_time := {end_time[.N] = end_time0[.N]; end_time}, .(driver, trip_id)] %>%
    .[,c("end_time0", "add1") := NULL] %>%
    .[, trip_time := as.integer(difftime(end_time, start_time, units = "mins"))] %>%
    setkey(driver, start_time, end_time) %>%
    .[, new_trip_id := .I] %>%
    .[, .(new_trip_id, driver, start_time, end_time, trip_time)]

  # 03. overlap ping and new trips
  pitr_df = ping_df %>%
    .[,dummy := ping_time] %>%
    setkey(driver, ping_time, dummy) %>%
    foverlaps(trip_df, type = "within",
              by.x = c("driver", "ping_time", "dummy"),
              mult = "first", nomatch = NA) %>%
    .[, dummy := NULL] %>%
    .[,.(ping_id, driver, ping_time, trip_id, new_trip_id,
         start_time, end_time, trip_time, lon, lat, speed,
         PRECIP_INTENSITY, PRECIP_PROBABILITY, WIND_SPEED,
         VISIBILITY, SUNRISE_TIME, SUNSET_TIME)]

  ovlap_tripid = pitr_df[, .N, new_trip_id][,N := NULL]
  unmat_trip = trip_df[!ovlap_tripid, on = "new_trip_id"]

  # 04. distance
  dist = pitr_df %>%
    .[,.(driver, trip_id, ping_id, lon, lat)] %>%
    .[,`:=`(lon1 = shift(lon, type = "lag", fill = NA),
            lat1 = shift(lat, type = "lag", fill = NA)),
      by = c("driver", "trip_id")] %>%
    .[,distance := distHaversine(cbind(lon, lat), cbind(lon1, lat1))] %>%
    .[,distance := round(distance/1609.344, 3)] %>%
    .[,.(ping_id, distance)] %>%
    setkey(ping_id)

  # 05. merge distance back to ping dat and add unmatched trips
  newtrip = dist %>%
    .[pitr_df, on = "ping_id"] %>%
    .[,.(start_time = start_time[1], end_time = end_time[1],
         trip_time = trip_time[1], mh_trip_id = trip_id[1],
         distance = sum(distance, na.rm = TRUE),
         start_lat = lat[1], start_lon = lon[1],
         end_lat = lat[.N], end_lon = lon[.N],
         ave_ping_speed = mean(speed, na.rm = TRUE),
         PRECIP_INTENSITY = mean(PRECIP_INTENSITY, na.rm = TRUE),
         PRECIP_PROBABILITY = mean(PRECIP_PROBABILITY, na.rm = TRUE),
         WIND_SPEED = mean(WIND_SPEED, na.rm = TRUE),
         VISIBILITY = mean(VISIBILITY, na.rm = TRUE)),
      by = c("driver", "new_trip_id")] %>%
    list(unmat_trip) %>%
    rbindlist(fill = TRUE) %>%
    setkey(driver, start_time)

  # 06. Critical Events
  # 06a. critical events table
  ce = fread(paste0(datapath, "CRITICAL_EVENT_QUERY2016-09-30 10-58-28.csv")) %>%
    .[,`:=`(EMPLID = stringr::str_replace_all(EMPLID, " ", ""),
            EVT_TYP = stringr::str_replace_all(EVT_TYP, " ", ""))] %>%
    .[,event_time := ymd_hms(paste(EVENT_DATE, EVENT_HOUR, sep = " "))]
  # 06b. driver information
  alldr = fread(paste0(datapath, "ALL_DRIVERS_DATA2016-09-30 10-53-42.csv")) %>%
    .[,EMPLID := stringr::str_replace_all(EMPLID, " ", "")]
  # 06c. alpha to employee ID
  alpha = fread(paste0(datapath, "ALPHA_TO_EMPLID2016-10-21 14-00-24.csv")) %>%
    .[,driver := tolower(ALPHA)] %>%
    .[,`:=`(driver = stringr::str_replace_all(driver, " ", ""),
            EMPLID = stringr::str_replace_all(EMPLID, " ", ""))] %>%
    .[,.(driver, EMPLID)] %>%
    setkey(driver)

  d500 = newtrip %>%
    .[,.N, driver] %>%
    setkey(driver)

  d = alpha %>%
    .[d500, on = "driver"] %>%
    setkey(EMPLID)# there are duplicated EMPLID

  d2 = alldr %>%
    .[d, on = "EMPLID"] %>%
    .[,BIRTHDATE := ymd(BIRTHDATE)] %>%
    .[!is.na(BIRTHDATE),] %>%
    setkey(driver) %>%
    .[,n_missing := rowSums(is.na(.))] %>%
    .[order(driver, -n_missing)] %>%
    .[,head(.SD, 1), by = driver] %>%
    .[, age := 2015 - year(BIRTHDATE)] %>%
    .[!(driver %in% c("kisi", "codc"))] %>%
    .[,.(driver, EMPLID, age)]

  ce0 = ce[EMPLID %in% d2[,EMPLID],]
  ce0 = alpha[ce0, on = "EMPLID"] %>%
    .[,.(driver, event_time, EVT_TYP)] %>%
    .[,EVT_TYP := dplyr::recode(EVT_TYP,
                                "HEADWAY" = "HW",
                                "HARD_BRAKING" = "HB",
                                "COLLISION_MITIGATION" = "CM",
                                "ROLL_STABILITY" = "RS")] %>%
    setkey(driver, event_time) %>%
    unique()

  # 07. Merge CE back to trips
  ce0 %>%
    .[,dummy := event_time] %>%
    setkey(driver, event_time, dummy)

  ce2merge = newtrip %>%
    setkey(driver, start_time, end_time) %>%
    foverlaps(ce0, mult = "all", type = "any",
              by.x = c("driver", "start_time", "end_time")) %>%
    .[, dummy := NULL] %>%
    .[!is.na(EVT_TYP),] %>%
    .[,.(new_trip_id, driver, event_time, EVT_TYP)] %>%
    .[,.(CE_num = .N,
         CE_time = paste(event_time, collapse = ";"),
         CE_type = paste(EVT_TYP, collapse = ";")),
      new_trip_id]

  newtrip_ce = ce2merge %>%
    .[newtrip, on = 'new_trip_id'] %>%
    .[,ave_dist_speed := distance*60/trip_time] %>%
    .[,ave_dist_speed := ifelse(ave_dist_speed >= 80,
                                ave_ping_speed, ave_dist_speed)] %>%
    setkey(driver, start_time)

  return(list(trip_has_CE = newtrip_ce,
              trip_no_CE  = newtrip,
              CE_alone    = ce0[,dummy := NULL]))
}


zz = rmk_trip()

fwrite(zz$CE_alone, paste0("gen_data/", today(), "_nt_CE_alone.csv"))
fwrite(zz$trip_no_CE, paste0("gen_data/", today(), "_nt_trip_no_CE.csv"))
fwrite(zz$trip_has_CE, paste0("gen_data/", today(), "_nt_trip_has_CE.csv"))
