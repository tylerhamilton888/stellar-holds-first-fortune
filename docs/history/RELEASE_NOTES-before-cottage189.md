# 0.123.1 — Clear corners

Miners reassigned to household freight now finish entering their current cell before following a new route. This prevents a tight tunnel corner from leaving a carrier repeatedly reporting a blocked route despite an open passage.

Freight checks now retain a replay seed and map/carrier/cargo snapshots if an assertion fails. Cargo, storage, stair access, costs and save formats are unchanged.

The original intermittent lower-level report remains separate; this fix addresses a reproduced mid-step reassignment failure. See CURRENT_STATUS.md for the verified published build. [Previous notes](history/RELEASE_NOTES-before-freight187.md).
