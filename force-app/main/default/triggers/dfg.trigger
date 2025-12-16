trigger dfg on Account (before insert) {
system.debug('this is my change');
}