-- PostgreSQL-compatible schema derived from onlineshop_db.sql
-- Notes:
-- 1) Oracle-specific objects (PL/SQL functions, packages, triggers, UTL_*/DBMS_* calls,
--    APEX packages, and complex sequences with Oracle options) were removed.
-- 2) Types were mapped roughly: NUMBER -> bigint/numeric, VARCHAR2(n) -> varchar(n),
--    DATE -> timestamp without time zone, BLOB -> bytea.
-- 3) Identifiers converted to lowercase snake_case for PostgreSQL conventions.
-- Review names/constraints and adjust types/keys as needed before use.

CREATE TABLE bus_item_master (
  item_id bigint,
  item_no varchar(16) NOT NULL,
  item_type varchar(20),
  item_category varchar(20),
  item_name varchar(100),
  item_description varchar(200),
  made_in varchar(50),
  active_status varchar(1),
  company_no bigint,
  created_by varchar(10),
  created_on timestamp without time zone,
  last_updated_by varchar(10),
  last_updated_on timestamp without time zone,
  unit_no varchar(16),
  sub_category varchar(50),
  PRIMARY KEY (item_no)
);

CREATE TABLE wms_store_mst (
  wsm_store_id bigint,
  wsm_store_no varchar(16),
  wsm_store_name varchar(255) NOT NULL,
  wsm_type varchar(20),
  wsm_parent_id varchar(16),
  wsm_address varchar(255),
  wsm_street_address varchar(255),
  wsm_city varchar(100),
  wsm_mobile_no varchar(50),
  wsm_phone_no varchar(50),
  wsm_description varchar(255),
  company_no bigint,
  active_status varchar(1),
  created_by varchar(16) NOT NULL,
  created_on timestamp without time zone NOT NULL,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone
);

CREATE TABLE wms_sh_invheader (
  sh_invoice_id bigint,
  sh_invoice_no varchar(16),
  sh_invoice_date timestamp without time zone NOT NULL,
  sh_registration_no varchar(16),
  sh_customer_id varchar(16),
  sh_customer_name varchar(100),
  sh_customer_contact varchar(100),
  customer_type varchar(3) NOT NULL,
  sh_invoice_status varchar(10),
  active_status varchar(1),
  company_no bigint,
  created_by varchar(16),
  created_on timestamp without time zone,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone,
  sh_inv_type varchar(5) NOT NULL,
  sh_remarks varchar(50),
  PRIMARY KEY (sh_invoice_no)
);

CREATE TABLE wms_sh_invline (
  sh_invline_no varchar(16) PRIMARY KEY,
  sh_invoice_no varchar(16),
  item_no varchar(16),
  sh_quantity numeric,
  item_rate numeric,
  item_unit varchar(16),
  sh_stock_code varchar(16),
  discount numeric,
  company_no bigint,
  created_by varchar(16),
  created_on timestamp without time zone,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone,
  retrun_qty numeric
);

CREATE TABLE bus_registration (
  registration_id bigint,
  registration_no varchar(16) NOT NULL,
  customer_name varchar(50),
  present_address varchar(100),
  mobile_no varchar(100),
  email varchar(50),
  gender varchar(10),
  customer_image bytea,
  active_status varchar(1),
  created_by varchar(16),
  created_on timestamp without time zone,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone,
  PRIMARY KEY (registration_no)
);

CREATE TABLE wms_sh_payment (
  sh_payment_id bigint,
  sh_mr_no varchar(20) PRIMARY KEY,
  sh_invoice_no varchar(16),
  sh_payment_date timestamp without time zone,
  sh_payment_purpose varchar(30),
  sh_payment_type varchar(30),
  sh_bill_amt numeric,
  sh_discount_amt numeric,
  sh_vat_amt numeric,
  sh_payable_amt numeric,
  sh_cashpaid_amt numeric,
  card_category varchar(9),
  card_type varchar(9),
  card_no varchar(30),
  owner_name varchar(20),
  expiry_date timestamp without time zone,
  charge_amt numeric,
  card_amt numeric,
  card_status varchar(9),
  card_charge_id bigint,
  sh_refund_flag varchar(1),
  sh_refund_against_mrno varchar(16),
  sh_refund_amount numeric,
  sh_refund_reason varchar(50),
  sh_refund_authority varchar(30),
  created_by varchar(16),
  created_on timestamp without time zone,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone,
  company_no bigint,
  discount_by varchar(64)
);

CREATE TABLE user_access (
  access_id bigint PRIMARY KEY,
  menu_id bigint,
  user_name varchar(200),
  access_type varchar(100),
  company_no bigint,
  active_status varchar(1),
  created_on timestamp without time zone,
  created_by varchar(32),
  last_updated_by varchar(32),
  last_updated_on timestamp without time zone
);

CREATE TABLE global_company_setup (
  company_id bigint,
  company_no bigint PRIMARY KEY,
  company_name varchar(100),
  address varchar(300),
  phone varchar(100),
  fax varchar(50),
  e_mail varchar(50),
  mobile varchar(50),
  logo bytea,
  active_status varchar(1),
  created_by varchar(16),
  created_on timestamp without time zone,
  updated_by varchar(16),
  updated_on timestamp without time zone
);

CREATE TABLE bus_unit_setup (
  unit_no varchar(16) PRIMARY KEY,
  unit_name varchar(100),
  description varchar(100),
  active_status varchar(1),
  company_no bigint,
  created_by varchar(10),
  created_on timestamp without time zone,
  last_updated_by varchar(10),
  last_updated_on timestamp without time zone
);

CREATE TABLE erp_main_application (
  id bigint PRIMARY KEY,
  parent_id bigint,
  application_id bigint,
  menu_id bigint,
  page_name varchar(200),
  page_num bigint,
  item_name text,
  item_value text,
  image varchar(32),
  active_status varchar(1)
);

CREATE TABLE wms_item_stock (
  stock_id bigint,
  stock_no varchar(16) NOT NULL PRIMARY KEY,
  item_no varchar(16) NOT NULL,
  wsm_code varchar(16) NOT NULL,
  opening_balance_qnt numeric DEFAULT 0 NOT NULL,
  opening_balance_rate numeric DEFAULT 0 NOT NULL,
  opening_balance_date timestamp without time zone NOT NULL,
  mrp numeric DEFAULT 0 NOT NULL,
  current_balance_qnt numeric DEFAULT 0 NOT NULL,
  reorder_level numeric DEFAULT 0 NOT NULL,
  active_status varchar(1),
  company_no bigint,
  created_by varchar(10),
  created_on timestamp without time zone,
  last_updated_by varchar(10),
  last_updated_on timestamp without time zone,
  current_pr_rate numeric
);

CREATE TABLE app_users_list (
  user_id bigint,
  user_name varchar(100) PRIMARY KEY,
  password varchar(4000),
  department varchar(200),
  expires_on timestamp without time zone,
  accesscode bigint,
  employee_no varchar(16),
  user_type varchar(64),
  active_status varchar(1),
  created_on timestamp without time zone,
  created_by varchar(32),
  last_updated_by varchar(32),
  last_updated_on timestamp without time zone
);

CREATE TABLE bus_price_list (
  price_line_no bigint PRIMARY KEY,
  price_list bigint,
  item_no varchar(16),
  rate numeric,
  mrp numeric,
  batch_no varchar(50),
  company_portion numeric,
  service_provider_portion numeric,
  active_status varchar(1),
  company_no bigint,
  created_by varchar(16),
  created_on timestamp without time zone,
  last_updated_by varchar(16),
  last_updated_on timestamp without time zone
);

-- NOTE: All PL/SQL functions, packages, triggers and APEX-specific code were intentionally
-- removed from this Postgres-focused file. If you want, I can port selected triggers
-- and stored procedures to PL/pgSQL or implement those rules in application logic (FastAPI).
