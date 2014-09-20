Kamerling
=========

Kamerling is a lightweight server for managing a network of computation clients.

HTTP API
--------

Minimal docs on the HTTP API (which happens to use XHTML and so should be mostly usable through a browser):

`GET /` returns links to clients (at `#clients [href]`) and project (at `#projects [href]`).

`GET /clients` contains information on and links to clients (at `#clients [data-class=client]`).

`GET /projects` contains links to projects (at `#projects [data-class=project]`).

`GET /projects/{uuid}` contains client (at `#clients [data-class=client]` and task (at `#tasks [data-class=task]`) information on a given project.

`POST /projects` creates a new project (given a `name` and an `uuid`).

`POST /projects/dispatch` dispatches tasks to all free clients.

© MMXIII-MMXIV Piotr Szotkowski <p.szotkowski@tele.pw.edu.pl>, licensed under AGPL 3 (see LICENCE)
