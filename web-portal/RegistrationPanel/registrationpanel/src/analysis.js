function analyzeBookings(data) {
    const timeSlotCount = {};
    const opdCount = {};
    let morningCount = 0;
    let eveningCount = 0;
  
    data.forEach(booking => {
      const timeSlot = booking['time_slot'];
      const opd = booking['OPD_dept'];
  
      if (timeSlot) {
        timeSlotCount[timeSlot] = (timeSlotCount[timeSlot] || 0) + 1;
  
        const isMorning = checkIfMorning(timeSlot);
        if (isMorning) {
          morningCount++;
        } else {
          eveningCount++;
        }
      }
  
      if (opd) {
        opdCount[opd] = (opdCount[opd] || 0) + 1;
      }
    });
  

    let maxTimeSlot = '', maxBookings = 0;
    for (const time in timeSlotCount) {
      if (timeSlotCount[time] > maxBookings) {
        maxBookings = timeSlotCount[time];
        maxTimeSlot = time;
      }
    }

    let maxOpd = '', maxOpdBookings = 0;
    for (const opd in opdCount) {
      if (opdCount[opd] > maxOpdBookings) {
        maxOpdBookings = opdCount[opd];
        maxOpd = opd;
      }
    }
  
    return {
      timeSlotWithMaxBookings: {
        time: maxTimeSlot,
        count: maxBookings
      },
      opdWithMaxBookings: {
        department: maxOpd,
        count: maxOpdBookings
      },
      timePeriodSummary: {
        morning: morningCount,
        evening: eveningCount,
        mostBookedPeriod: morningCount > eveningCount ? "Morning" : (eveningCount > morningCount ? "Evening" : "Equal")
      },
      allTimeSlotCounts: timeSlotCount,
      allOpdCounts: opdCount
    };
  }
  
  function checkIfMorning(timeString) {
    if (!timeString) return false;
  
    const [time, period] = timeString.split(' ');
    const [hour] = time.split(':').map(Number);
  

    return period.toUpperCase() === "AM";
  }
  
  export default analyzeBookings;
  