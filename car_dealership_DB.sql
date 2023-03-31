
-- city table

create table city(
	city_id SERIAL primary key,
	city_name VARCHAR(200),
	state_ VARCHAR(100),
	country VARCHAR(200),
	zipcode NUMERIC(5)
);

-- billing info table

create table billing(
	billing_id SERIAL primary key,
	billing_type VARCHAR(100),
	billing_info VARCHAR(100)
);

-- customer table

create table customer(
	customer_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	address VARCHAR(150),
	city_id Integer,
	billing_id Integer,
	foreign key(city_id) references city(city_id),
	foreign key(billing_id) references billing(billing_id)
);

-- staff table

create table staff(
	staff_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	position_ VARCHAR(100)
);

-- sold_cars table

create table sold_cars(
	car_id SERIAL primary key,
	make_ VARCHAR(100),
	model_ VARCHAR(100),
	year_ VARCHAR(20),
	customer_id INTEGER,
	staff_id integer,
	foreign key(customer_id) references customer(customer_id),
	foreign key(staff_id) references staff(staff_id)
);

-- cars table

create table cars(
	car_id SERIAL primary key,
	make_ VARCHAR(100),
	model_ VARCHAR(100),
	year_ VARCHAR(20)
);

-- invoice table

create table invoice(
	invoice_id SERIAL primary key,
	date_ DATE default current_date,
	total_amount NUMERIC(10,2),
	customer_id integer,
	staff_id integer,
	car_id integer,
	foreign key(customer_id) references customer(customer_id),
	foreign key(staff_id) references staff(staff_id),
	foreign key(car_id) references cars(car_id)
);

-- service_ticket table

create table service_ticket(
	ticket_id SERIAL primary key,
	date_ date default current_date,
	service_info VARCHAR(5000),
	total_amount numeric(10,2),
	customer_id integer,
	staff_id integer,
	car_id integer,
	foreign key(customer_id) references customer(customer_id),
	foreign key(staff_id) references staff(staff_id),
	foreign key(car_id) references cars(car_id)
);

-- records table

create table records(
	record_id SERIAL primary key,
	ticket_id integer,
	foreign key(ticket_id) references service_ticket(ticket_id)
);

alter table records
add car_id INTEGER;

alter table records
add foreign key (car_id) references sold_cars(car_id);

-- adding billing information

insert into billing(billing_id, billing_type, billing_info)
values(1, 'credit', '1234-5678-9012-3456'); 

insert into billing(billing_id, billing_type, billing_info)
values(2, 'credit', '0987-6543-2109-8765'); 

select * from billing;

-- add city information

insert into city(city_id, city_name, state_, country, zipcode)
values(66821, 'Saratoga Springs', 'NY', 'United States', 12866);

select * from city;

-- add customer info

insert into customer(customer_id, first_name, last_name, address, city_id, billing_id)
values(1, 'John', 'Smith', '123 Broadway', 66821, 1);

insert into customer(customer_id, first_name, last_name, address, city_id, billing_id)
values(2, 'Bill', 'Black', '456 Broadway', 66821, 2);

select * from customer;

-- add staff info 

insert into staff(staff_id, first_name, last_name, position_)
values(1, 'Jane', 'Doe', 'Manager');

select * from staff;

-- add sold_cars info

insert into sold_cars(car_id, make_, model_, year_, customer_id, staff_id)
values(1, 'Ford', 'Bronco', '2023', 1, 1);

select * from sold_cars;

-- add cars info

insert into cars(car_id, make_, model_, year_)
values(1, 'Chevy', 'Silverado', '2023');

select * from cars;

-- add invoice info

insert into invoice(invoice_id, date_, total_amount, customer_id, staff_id, car_id)
values(1, current_date, 93400.90, 2, 1, 1);

select * from invoice;

-- add service_ticket info

insert into service_ticket(ticket_id, date_, service_info, total_amount, car_id, customer_id, staff_id)
values(1, current_date, 'replaced brakes', 2020.45, 1, 1, 1);

select * from service_ticket;

-- add records info

insert into records(record_id, ticket_id, car_id)
values(2,1,1);

select * from records;


-- function to add customer information
create or replace function add_customer(
	_customer_id INTEGER, 
	_first_name VARCHAR, 
	_last_name VARCHAR, 
	_address VARCHAR, 
	_billing_id INTEGER,
	_billing_type VARCHAR,
	_billing_info VARCHAR,
	_city_id INTEGER,
	_city_name VARCHAR,
	_state_ VARCHAR,
	_country VARCHAR,
	_zipcode NUMERIC
)
returns void
as $MAIN$
begin 
	insert into billing(billing_id, billing_type, billing_info)
	values(_billing_id, _billing_type, _billing_info);
	insert into city(city_id, city_name, state_, country, zipcode)
	values(_city_id, _city_name, _state_, _country, _zipcode);
	insert into customer(customer_id, first_name, last_name, address, city_id, billing_id)
	values(_customer_id, _first_name, _last_name, _address, _city_id, _billing_id);
end;
$MAIN$
language plpgsql;


-- function to add staff member
create or replace function add_staff(
	_staff_id INTEGER,
	_first_name VARCHAR,
	_last_name VARCHAR,
	_position_ VARCHAR
)
returns void
as $MAIN$
begin 
	insert into staff(staff_id, first_name, last_name, position_)
	values(_staff_id, _first_name, _last_name, _position_);
end;
$MAIN$
language plpgsql;


-- function to add sold cars aka cars that need maintenance 
create or replace function add_sold_cars(
	_car_id INTEGER, 
	_make_ VARCHAR, 
	_model_ VARCHAR, 
	_year_ VARCHAR, 
	_customer_id INTEGER,
	_staff_id INTEGER
)
returns void
as $MAIN$
begin 
	insert into sold_cars(car_id, make_, model_, year_, customer_id, staff_id)
	values(_car_id, _make_, _model_, _year_, _customer_id, _staff_id);
end;
$MAIN$
language plpgsql;


-- function to add cars
create or replace function add_cars(
	_car_id INTEGER, 
	_make_ VARCHAR, 
	_model_ VARCHAR, 
	_year_ VARCHAR 
)
returns void
as $MAIN$
begin 
	insert into cars(car_id, make_, model_, year_)
	values(_car_id, _make_, _model_, _year_);
end;
$MAIN$
language plpgsql;


-- function to add an invoice 
create or replace function add_invoice(
	_invoice_id INTEGER,
	_date_ DATE,
	_total_amount numeric,
	_customer_id INTEGER,
	_staff_id INTEGER,
	_car_id INTEGER
)
returns void
as $MAIN$
begin 
	insert into invoice(invoice_id, date_, total_amount, customer_id, staff_id, car_id)
	values(_invoice_id, _date_, _total_amount, _customer_id, _staff_id, _car_id);
end;
$MAIN$
language plpgsql;


-- function to add service tickets
create or replace function add_service_ticket(
	_ticket_id INTEGER,
	_date_ DATE,
	_service_info VARCHAR,
	_total_amount numeric,
	_customer_id integer,
	_staff_id integer,
	_car_id integer
)
returns void
as $MAIN$
begin 
	insert into service_ticket(ticket_id, date_, service_info, total_amount, customer_id, staff_id, car_id)
	values(_ticket_id, _date_, _service_info, _total_amount, _customer_id, _staff_id, _car_id);
end;
$MAIN$
language plpgsql;


-- function to add records
create or replace function add_records(
	_record_id integer,
	_ticket_id integer,
	_car_id integer
)
returns void
as $MAIN$
begin 
	insert into records(record_id, ticket_id, car_id)
	values(_record_id, _ticket_id, _car_id);
end;
$MAIN$
language plpgsql;


select add_customer
(3, 'Jeff', 'Gordon', '777 Seventh St', 3, 'credit', '1234-0987-6543-5678', 23456, 'Spanish Fork', 'UT', 'United States', 87234);

select * from customer;

select * from billing;
 
select * from city;

select add_staff(2, 'Sally', 'Fields', 'Mechanic');

select * from staff;

select add_sold_cars(2, 'Subaru', 'Outback', '2008', 3, 2);

select * from sold_cars;

select add_cars(2, 'Ford', 'F-350 Super Duty', '2022');

select * from cars;

select add_invoice(2, current_date, 87500.00, 3, 1, 2);

select * from invoice;

select add_service_ticket(2, current_date, 'oil change', 350.75, 3, 2, 2);

select * from service_ticket;

select add_records(3, 2, 2);

select * from records;







