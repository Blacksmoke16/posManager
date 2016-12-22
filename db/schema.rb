# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160704195408) do

  create_table "corps", force: :cascade do |t|
    t.integer "corpID",       limit: 4
    t.string  "corpName",     limit: 255
    t.integer "allianceID",   limit: 4
    t.string  "allianceName", limit: 255
    t.string  "keyID",        limit: 255
    t.string  "vCode",        limit: 255
  end

  create_table "invcategories", primary_key: "categoryID", force: :cascade do |t|
    t.string  "categoryName", limit: 100
    t.integer "iconID",       limit: 4
    t.boolean "published"
  end

  create_table "invgroups", primary_key: "groupID", force: :cascade do |t|
    t.integer "categoryID",           limit: 4
    t.string  "groupName",            limit: 100
    t.integer "iconID",               limit: 4
    t.boolean "useBasePrice"
    t.boolean "anchored"
    t.boolean "anchorable"
    t.boolean "fittableNonSingleton"
    t.boolean "published"
  end

  add_index "invgroups", ["categoryID"], name: "ix_invGroups_categoryID", using: :btree

  create_table "invtypematerials", id: false, force: :cascade do |t|
    t.integer "typeID",         limit: 4, null: false
    t.integer "materialTypeID", limit: 4, null: false
    t.integer "quantity",       limit: 4, null: false
  end

  create_table "invtypes", primary_key: "typeID", force: :cascade do |t|
    t.integer "groupID",       limit: 4
    t.string  "typeName",      limit: 100
    t.text    "description",   limit: 65535
    t.float   "mass",          limit: 53
    t.float   "volume",        limit: 53
    t.float   "capacity",      limit: 53
    t.integer "portionSize",   limit: 4
    t.integer "raceID",        limit: 4
    t.decimal "basePrice",                   precision: 19, scale: 4
    t.boolean "published"
    t.integer "marketGroupID", limit: 4
    t.integer "iconID",        limit: 4
    t.integer "soundID",       limit: 4
    t.integer "graphicID",     limit: 4
  end

  add_index "invtypes", ["groupID"], name: "ix_invTypes_groupID", using: :btree

  create_table "mapconstellations", primary_key: "constellationID", force: :cascade do |t|
    t.integer "regionID",          limit: 4
    t.string  "constellationName", limit: 100
    t.float   "x",                 limit: 53
    t.float   "y",                 limit: 53
    t.float   "z",                 limit: 53
    t.float   "xMin",              limit: 53
    t.float   "xMax",              limit: 53
    t.float   "yMin",              limit: 53
    t.float   "yMax",              limit: 53
    t.float   "zMin",              limit: 53
    t.float   "zMax",              limit: 53
    t.integer "factionID",         limit: 4
    t.float   "radius",            limit: 24
  end

  create_table "mapdenormalize", primary_key: "itemID", force: :cascade do |t|
    t.integer "typeID",          limit: 4
    t.integer "groupID",         limit: 4
    t.integer "solarSystemID",   limit: 4
    t.integer "constellationID", limit: 4
    t.integer "regionID",        limit: 4
    t.integer "orbitID",         limit: 4
    t.float   "x",               limit: 53
    t.float   "y",               limit: 53
    t.float   "z",               limit: 53
    t.float   "radius",          limit: 53
    t.string  "itemName",        limit: 100
    t.float   "security",        limit: 53
    t.integer "celestialIndex",  limit: 4
    t.integer "orbitIndex",      limit: 4
  end

  add_index "mapdenormalize", ["constellationID"], name: "ix_mapDenormalize_constellationID", using: :btree
  add_index "mapdenormalize", ["groupID", "constellationID"], name: "mapDenormalize_IX_groupConstellation", using: :btree
  add_index "mapdenormalize", ["groupID", "regionID"], name: "mapDenormalize_IX_groupRegion", using: :btree
  add_index "mapdenormalize", ["groupID", "solarSystemID"], name: "mapDenormalize_IX_groupSystem", using: :btree
  add_index "mapdenormalize", ["orbitID"], name: "ix_mapDenormalize_orbitID", using: :btree
  add_index "mapdenormalize", ["regionID"], name: "ix_mapDenormalize_regionID", using: :btree
  add_index "mapdenormalize", ["solarSystemID"], name: "ix_mapDenormalize_solarSystemID", using: :btree
  add_index "mapdenormalize", ["typeID"], name: "ix_mapDenormalize_typeID", using: :btree

  create_table "mapregions", primary_key: "regionID", force: :cascade do |t|
    t.string  "regionName", limit: 100
    t.float   "x",          limit: 53
    t.float   "y",          limit: 53
    t.float   "z",          limit: 53
    t.float   "xMin",       limit: 53
    t.float   "xMax",       limit: 53
    t.float   "yMin",       limit: 53
    t.float   "yMax",       limit: 53
    t.float   "zMin",       limit: 53
    t.float   "zMax",       limit: 53
    t.integer "factionID",  limit: 4
    t.float   "radius",     limit: 24
  end

  create_table "mapsolarsystems", primary_key: "solarSystemID", force: :cascade do |t|
    t.integer "regionID",        limit: 4
    t.integer "constellationID", limit: 4
    t.string  "solarSystemName", limit: 100
    t.float   "x",               limit: 53
    t.float   "y",               limit: 53
    t.float   "z",               limit: 53
    t.float   "xMin",            limit: 53
    t.float   "xMax",            limit: 53
    t.float   "yMin",            limit: 53
    t.float   "yMax",            limit: 53
    t.float   "zMin",            limit: 53
    t.float   "zMax",            limit: 53
    t.float   "luminosity",      limit: 53
    t.boolean "border"
    t.boolean "fringe"
    t.boolean "corridor"
    t.boolean "hub"
    t.boolean "international"
    t.boolean "regional"
    t.boolean "constellation"
    t.float   "security",        limit: 53
    t.integer "factionID",       limit: 4
    t.float   "radius",          limit: 53
    t.integer "sunTypeID",       limit: 4
    t.string  "securityClass",   limit: 2
  end

  add_index "mapsolarsystems", ["constellationID"], name: "ix_mapSolarSystems_constellationID", using: :btree
  add_index "mapsolarsystems", ["regionID"], name: "ix_mapSolarSystems_regionID", using: :btree
  add_index "mapsolarsystems", ["security"], name: "ix_mapSolarSystems_security", using: :btree

  create_table "pos", id: false, force: :cascade do |t|
    t.integer  "itemID",                limit: 8
    t.string   "itemName",              limit: 255
    t.integer  "typeID",                limit: 4
    t.string   "typeName",              limit: 255
    t.integer  "locationID",            limit: 4
    t.string   "locationName",          limit: 255
    t.integer  "fuelAmount",            limit: 4
    t.integer  "fuelType",              limit: 4
    t.string   "fuelTypeName",          limit: 255
    t.integer  "fuelConsumption",       limit: 4
    t.integer  "strontAmount",          limit: 4
    t.integer  "strontConsumption",     limit: 4
    t.integer  "siloCapacity",          limit: 4
    t.integer  "regionID",              limit: 4
    t.string   "regionName",            limit: 255
    t.integer  "constellationID",       limit: 4
    t.string   "constellationName",     limit: 255
    t.integer  "moonID",                limit: 4
    t.string   "state",                 limit: 255
    t.datetime "stateTimestamp"
    t.datetime "onlineTimestamp"
    t.integer  "corpID",                limit: 4
    t.integer  "allianceID",            limit: 4
    t.boolean  "sovBonus"
    t.boolean  "allowAllianceUsage"
    t.boolean  "allowCorporationUsage"
    t.boolean  "siphon"
    t.integer  "x",                     limit: 8
    t.integer  "y",                     limit: 8
    t.integer  "z",                     limit: 8
    t.integer  "posCapacity",           limit: 4
  end

  create_table "pos_tracker_users", force: :cascade do |t|
    t.integer "characterID", limit: 4
    t.integer "posID",       limit: 8
    t.boolean "visible"
    t.text    "note",        limit: 65535
  end

  create_table "silos", id: false, force: :cascade do |t|
    t.integer "itemID",     limit: 8
    t.integer "posID",      limit: 8
    t.integer "corpID",     limit: 4
    t.string  "siloName",   limit: 255
    t.integer "locationID", limit: 4
    t.integer "gooTypeID",  limit: 4
    t.integer "gooGroupID", limit: 4
    t.integer "gooAmount",  limit: 4
    t.string  "gooName",    limit: 255
    t.decimal "gooVolume",              precision: 10, scale: 5
    t.integer "x",          limit: 8
    t.integer "y",          limit: 8
    t.integer "z",          limit: 8
  end

  create_table "sovlist", id: false, force: :cascade do |t|
    t.integer "solarSystemID",   limit: 8
    t.string  "solarSystemName", limit: 255
    t.integer "corpID",          limit: 4
    t.integer "allianceID",      limit: 4
    t.integer "factionID",       limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.integer "characterID",   limit: 4
    t.string  "characterName", limit: 255
    t.integer "corpID",        limit: 4
    t.string  "corpName",      limit: 255
    t.integer "allianceID",    limit: 4
    t.string  "allianceName",  limit: 255
  end

end
