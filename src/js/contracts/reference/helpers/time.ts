const addDaysFn = require('date-fns/addDays');

const MS_IN_SECOND = 1000;

type DurationFormat = 's' | 'ms';

export const duration = {
  milliseconds(val: number) {
    return val;
  },
  seconds(val: number, format: DurationFormat = 'ms') {
    return format === 'ms'
      ? val * this.milliseconds(MS_IN_SECOND)
      : val
  },
  minutes(val: number, format: DurationFormat = 'ms') {
    return val * this.seconds(60, format);
  },
  hours(val: number, format: DurationFormat = 'ms') {
    return val * this.minutes(60, format);
  },
  days(val: number, format: DurationFormat = 'ms') {
    return val * this.hours(24, format);
  },
  weeks(val: number, format: DurationFormat = 'ms') {
    return val * this.days(7, format);
  },
  years(val: number, format: DurationFormat = 'ms') {
    return val * this.days(365, format);
  }
};

export const now = () => Date.now();
export const addDays = (ts: number, days: number) => addDaysFn(ts, days);
export const getTs = (date: string) => (new Date(date)).getTime();
export const msToSeconds = (ts: number) => Math.floor(ts / 1000)
