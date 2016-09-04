# Toppr GOT API
pre-requisites: ruby 2.3.1, rails 2.4.7, postgres

**Deploy**

 * add following environment variables to the server
   * DB_USER = < your postgres username >
   * DB_PASS = < your postgres password >
   * SECRET_KEY_BASE = random string to act as secret key base for the rails app
 * run `rake db:create db:migrate` to initialize the DB
 * run `rake import:battles` to import the data from db/battles.csv into the DB

**Demo Url**
[www.shubham2.info](http://www.shubham2.info)
deployed on AWS EC2
running on nginx + passenger

**Details**

* it is a rest-ful api, responding to html and json formats (append .json to the end for requesting json content)
* the CRUD operations respond to both html and json content-type
* the CRUD operations are mounted at `/battles`, for example -
  * GET `/battles` for index in html format
  * GET `/battles.json` for index in json format
* end-points other than `/battles`, respond only to json format (no need to append .json at the end for these)
* those end-points are as follows
  * `/list` a list of places
  * `/count` returns total number of records
  * `/stats`returns some stats regarding the battles
  *  `/search`used to search the database
* the search end-point can be used to query the database on the basis of following attributes -
  * name
  * location
  * attacker_king
  * defender_king
  * battle_type
* multiple attributes can be chained together to form an `AND` condition for the search, for example - 
  * to search the battles in which the name contains 'abc' and location contains 'xyz', then use - `GET /search?name=abc&location=xyz`
  * `GET /search?name=abc&location=def&attacker_king=ghi&defender_king=jkl&battle_type=mno`
