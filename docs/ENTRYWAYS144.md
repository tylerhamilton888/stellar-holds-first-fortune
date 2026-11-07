# Mine entryways — 0.102.1

HoldMineEntrance owns the interior surface doorway, its saved north-wall location, narrow interaction/crossing throat, jamb collision, arrival offset and shared masonry painter. Deepworks.ENTRY remains the freight/service anchor, preserving jobs, cargo handling and existing layouts. Entryway placement adds only `entryway144` coordinates to the mine record; it does not reseed any map or delete/move furniture. An occupied preferred north bay tries nearby clear bays first.

HoldMineworks143 owns saved `returns144` arrival-bay doors and the existing seal/bridge requirements. Return doors move to row six, against the cleared bay's north wall; arrivals stand two tiles inward. The original adit and eastward gated passages retain their connection ownership. All doors use upright framing; side headings use an oblique face with upright pillars. Optional 3D captures the same painter.

The original five depths, excavations, room/district records, cart cargo, links and campaign requirements remain unchanged. First creation of an annex after a JSON load casts the persisted seed to int before modulo; previously that path could fail before allocating its map.

`entryways144` exercises the former accidental crossing, real E and walking exits, held-input arrival, jamb collision, walking past, freight delivery, old furniture placement, JSON reload, first annex entry from a loaded game and both camera representations. It joins full native validation and the exported catalogue. Existing mineworks, roads, first-shift and navigation cases protect connected travel and work. Review their native images at gameplay size. Publication remains a separate build step.
