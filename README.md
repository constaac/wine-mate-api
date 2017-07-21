![Wine Buddy Logo](http://i.imgur.com/WLWCTLl.png)

## Deployment and API URLs

* [Wine Buddy Deployment]()
* [Winy Buddy API URL]()
* [Wine Buddy Front-End Repo](https://github.com/constaac/wine-mate-front-end)
* [Wine Buddy Wiki](https://github.com/constaac/wine-mate-front-end/wiki)

## Technologies Used

* [`rails-api`](https://github.com/rails-api/rails-api)
* [`rails`](https://github.com/rails/rails)
* [`active_model_serializers`](https://github.com/rails-api/active_model_serializers)
* [`ruby`](https://www.ruby-lang.org/en/)
* [`postgres`](http://www.postgresql.org)
* [heroku](https://www.heroku.com/home)

This API was built in Ruby and is entirely powered by Ruby on Rails. It is backed
by a Postgres SQL database, which Rails communicates with using Active Record.

## Dependencies

Fork and Clone this repository.
Install with `bundle install`.

## Testing Scripts and Development Tasks

-   `bin/rake routes` lists the endpoints available in your API.
-   `bin/rake test` runs automated tests.
-   `bin/rails console` opens a REPL that pre-loads the API.
-   `bin/rails db` opens your database client and loads the correct database.
-   `bin/rails server` starts the API.
-   `scripts/*.sh` run various `curl` commands to test the API. See below.

## ERD Diagram

![Wine Buddy ERD](http://i.imgur.com/8OsRaUy.png)

## Development Approach

The development process began with envisioning what kind of resources my application
would have to persist. After wireframing, I came to the conclusion that my user stories
were revolving around creating a list for a collection and a list for a wish list. Since
I didn't plan on making my application a social network of sorts, I didn't need to make
users' lists public to others, and since users currently one have one list for each resource,
my ERD was pretty straight foreward to develop.

The ERD revolves around users owning inventory items and wish-list items. These two
resources are stores in two different tables, and belong to users via user ID. Users
share a one-to-many relationship with both Inventory items and Wish List items.

From that point, I simply scaffolded my resources, and then customized them to protect
against malicious curl scripting from other users. To do this, I used the OpenReadController
class to require authentication, set current user via auth Token, and then only allow
requests that affected entries that belonged to the user associated with the token.

## Hurdles and Unsolved Problems

The development process for the API was pretty straightforeward. I didn't run into
many issues.

One difficult aspect was the fact that I had built the back end before I began building
the front end. Since I didn't know what routes the Ember applicaiton was going to
expect, I had to do some guesswork in the meantime. I wound up setting things up well
enough that I didn't have to edit any of the routes.

## API

Routes: Authentication, Inventories, and Wish Lists

Scripts are included in [`scripts`](scripts) to test built-in actions.

### Authentication

| Verb   | URI Pattern            | Controller#Action |
|--------|------------------------|-------------------|
| POST   | `/sign-up`             | `users#signup`    |
| POST   | `/sign-in`             | `users#signin`    |
| PATCH  | `/change-password/:id` | `users#changepw`  |
| DELETE | `/sign-out/:id`        | `users#signout`   |

#### POST /sign-up

Request:

```sh
curl http://localhost:4741/sign-up \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'",
      "password_confirmation": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-up.sh
```

Response:

```md
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com"
  }
}
```

#### POST /sign-in

Request:

```sh
curl http://localhost:4741/sign-in \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-in.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com",
    "token": "BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f"
  }
}
```

#### PATCH /change-password/:id

Request:

```sh
curl --include --request PATCH "http://localhost:4741/change-password/$ID" \
  --header "Authorization: Token token=$TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "passwords": {
      "old": "'"${OLDPW}"'",
      "new": "'"${NEWPW}"'"
    }
  }'
```

```sh
ID=1 OLDPW=hannah NEWPW=elle TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/change-password.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

#### DELETE /sign-out/:id

Request:

```sh
curl http://localhost:4741/sign-out/$ID \
  --include \
  --request DELETE \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=1 TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/sign-out.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

### Inventories

| Verb   | URI Pattern            | Controller#Action     |
|--------|------------------------|-----------------------|
| GET    | `/inventories`         | `inventories#index`   |
| GET    | `/inventories/:id`     | `inventories#show`    |
| POST   | `/inventories`         | `inventories#create`  |
| PATCH  | `/inventories/:id`     | `inventories#update`  |
| DELETE | `/inventories/:id`     | `inventories#destroy` |

#### GET /inventories

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/inventories"
curl "${API}${URL_PATH}" \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=<token> scripts/index-inv.sh
```

Response:

```md
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
ETag: W/"216834a662c6dcd056720ece05d6194f"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: f0cf83c5-7557-4dbc-a52c-5e4c5bca65a0
X-Runtime: 0.392036
Vary: Origin
Transfer-Encoding: chunked

{"inventories":[]}
```

#### GET /inventories/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/inventories/${ID}"
curl "${API}${URL_PATH}" \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=<token> ID=1 sh scripts/show-inv.sh
```

Response:

```md
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
ETag: W/"370c3c9f61a311e13a207824f3588583"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 757a6d38-05da-4f7a-81ba-3764a8b608f6
X-Runtime: 0.376739
Vary: Origin
Transfer-Encoding: chunked

{"inventory":{"id":1,"name":"testname","winery":"","size":"Standard","location":null,"vintage":null,"grape":null,"quantity":1}}
```

#### POST /inventories

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/inventories"
curl "${API}${URL_PATH}" \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "inventory": {
      "name": "'${NAME}'",
      "winery": "'${WINERY}'",
    }
  }'
```

```sh
TOKEN=<token> NAME=name WINERY=winery sh scripts/create-inv.sh
```

Response:

```md
HTTP/1.1 201 Created
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: http://localhost:4741/inventories/32
Content-Type: application/json; charset=utf-8
ETag: W/"370c3c9f61a311e13a207824f3588583"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 27072928-6f11-405a-84ae-8997c367f13b
X-Runtime: 1.024435
Vary: Origin
Transfer-Encoding: chunked

{"inventory":{"id":1,"name":"testname","winery":"","size":"Standard","location":null,"vintage":null,"grape":null,"quantity":1}}
```

#### PATCH /inventories/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/inventories"
curl "${API}${URL_PATH}/${ID}" \
  --include \
  --request PATCH \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "inventory": {
      "name": "'${NAME}'"
    }
  }'
```

```sh
TOKEN=<token> ID=1 NAME=NewName sh scripts/update-inv.sh
```

Response:

```md
HTTP/1.1 204 No Content
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Cache-Control: no-cache
X-Request-Id: 67719567-09a9-4fdd-8579-35b33d7ae4dd
X-Runtime: 0.565348
Vary: Origin
```

#### DELETE /inventories/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/inventories/${ID}"
curl "${API}${URL_PATH}" \
  --include \
  --request DELETE \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=1 TOKEN=<token> scripts/destroy-inv.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

### Wish Lists

| Verb   | URI Pattern            | Controller#Action     |
|--------|------------------------|-----------------------|
| GET    | `/wish_lists`         | `wish_lists#index`     |
| GET    | `/wish_lists/:id`     | `wish_lists#show`      |
| POST   | `/wish_lists`         | `wish_lists#create`    |
| PATCH  | `/wish_lists/:id`     | `wish_lists#update`    |
| DELETE | `/wish_lists/:id`     | `wish_lists#destroy`   |

#### GET /inventories

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists"
curl "${API}${URL_PATH}" \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=<token> scripts/index-wl.sh
```

Response:

```md
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
ETag: W/"939bd2db777351a117e09fb9aa814a0c"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 453ba726-fb11-4e7c-a15c-0edea92033ac
X-Runtime: 0.428107
Vary: Origin
Transfer-Encoding: chunked

{"wish_lists":[]}
```

#### GET /wish_lists/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists/${ID}"
curl "${API}${URL_PATH}" \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=<token> ID=1 sh scripts/show-wl.sh
```

Response:

```md
HTTP/1.1 200 OK
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Content-Type: application/json; charset=utf-8
ETag: W/"370c3c9f61a311e13a207824f3588583"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 757a6d38-05da-4f7a-81ba-3764a8b608f6
X-Runtime: 0.376739
Vary: Origin
Transfer-Encoding: chunked

{"wish_list":{"id":1,"name":"testname","winery":"winery","size":"Standard","location":null,"vintage":null,"grape":null}}
```

#### POST /wish_lists

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists"
curl "${API}${URL_PATH}" \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "wish_list": {
      "name": "'${NAME}'",
      "winery": "'${WINERY}'",
    }
  }'
```

```sh
TOKEN=<token> NAME=testname WINERY=winery sh scripts/create-wl.sh
```

Response:

```md
HTTP/1.1 201 Created
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Location: http://localhost:4741/wish_lists/32
Content-Type: application/json; charset=utf-8
ETag: W/"370c3c9f61a311e13a207824f3588583"
Cache-Control: max-age=0, private, must-revalidate
X-Request-Id: 27072928-6f11-405a-84ae-8997c367f13b
X-Runtime: 1.024435
Vary: Origin
Transfer-Encoding: chunked

{"wish_list":{"id":1,"name":"testname","winery":"winery","size":"Standard","location":null,"vintage":null,"grape":null}}
```

#### PATCH /wish_lists/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists"
curl "${API}${URL_PATH}/${ID}" \
  --include \
  --request PATCH \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "wish_list": {
      "name": "'${NAME}'"
    }
  }'
```

```sh
TOKEN=<token> ID=1 NAME=NewName sh scripts/update-wl.sh
```

Response:

```md
HTTP/1.1 204 No Content
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Cache-Control: no-cache
X-Request-Id: 67719567-09a9-4fdd-8579-35b33d7ae4dd
X-Runtime: 0.565348
Vary: Origin
```

#### DELETE /wish_lists/:id

Request:

```sh
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/wish_lists/${ID}"
curl "${API}${URL_PATH}" \
  --include \
  --request DELETE \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=1 TOKEN=<token> scripts/destroy-wl.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

### Reset Database without dropping

This is not a task developers should run often, but it is sometimes necessary.

**locally**

```sh
bin/rake db:migrate VERSION=0
bin/rake db:migrate db:seed db:examples
```
