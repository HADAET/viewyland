CREATE TABLE  "BUS_ITEM_MASTER" 
   (	"ITEM_ID" NUMBER NOT NULL ENABLE, 
	"ITEM_NO" VARCHAR2(16) NOT NULL ENABLE, 
	"ITEM_TYPE" VARCHAR2(20), 
	"ITEM_CATEGORY" VARCHAR2(20), 
	"ITEM_NAME" VARCHAR2(100), 
	"ITEM_DESCRIPTION" VARCHAR2(200), 
	"MADE_IN" VARCHAR2(50), 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"COMPANY_NO" NUMBER, 
	"CREATED_BY" VARCHAR2(10), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(10), 
	"LAST_UPDATED_ON" DATE, 
	"UNIT_NO" VARCHAR2(16), 
	"SUB_CATEGORY" VARCHAR2(50), 
	 CONSTRAINT "PK_ITEM_NO" PRIMARY KEY ("ITEM_NO")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "WMS_STORE_MST" 
   (	"WSM_STORE_ID" NUMBER NOT NULL ENABLE, 
	"WSM_STORE_NO" VARCHAR2(16), 
	"WSM_STORE_NAME" VARCHAR2(255) NOT NULL ENABLE, 
	"WSM_TYPE" VARCHAR2(20), 
	"WSM_PARENT_ID" VARCHAR2(16), 
	"WSM_ADDRESS" VARCHAR2(255), 
	"WSM_STREET_ADDRESS" VARCHAR2(255), 
	"WSM_CITY" VARCHAR2(100), 
	"WSM_MOBILE_NO" VARCHAR2(50), 
	"WSM_PHONE_NO" VARCHAR2(50), 
	"WSM_DESCRIPTION" VARCHAR2(255), 
	"COMPANY_NO" NUMBER, 
	 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"CREATED_BY" VARCHAR2(16) NOT NULL ENABLE, 
	"CREATED_ON" DATE NOT NULL ENABLE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_WSM_STORE_NO" PRIMARY KEY ("WSM_STORE_NO")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "WMS_SH_INVHEADER" 
   (	"SH_INVOICE_ID" NUMBER NOT NULL ENABLE, 
	"SH_INVOICE_NO" VARCHAR2(16), 
	"SH_INVOICE_DATE" DATE NOT NULL ENABLE, 
	"SH_REGISTRATION_NO" VARCHAR2(16), 
	"SH_CUSTOMER_ID" VARCHAR2(16), 
	"SH_CUSTOMER_NAME" VARCHAR2(100), 
	"SH_CUSTOMER_CONTACT" VARCHAR2(100), 
	"CUSTOMER_TYPE" VARCHAR2(3) NOT NULL ENABLE, 
	"SH_INVOICE_STATUS" VARCHAR2(10), 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"COMPANY_NO" NUMBER, 
	 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	"SH_INV_TYPE" VARCHAR2(5) NOT NULL ENABLE, 
	"SH_REMARKS" VARCHAR2(50), 
	 CONSTRAINT "PK_SH_INVOICE_NO" PRIMARY KEY ("SH_INVOICE_NO")
  USING INDEX  ENABLE
   )
/
CREATE TABLE  "WMS_SH_INVLINE" 
   (	"SH_INVLINE_NO" VARCHAR2(16), 
	"SH_INVOICE_NO" VARCHAR2(16), 
	"ITEM_NO" VARCHAR2(16), 
	"SH_QUANTITY" NUMBER, 
	"ITEM_RATE" NUMBER, 
	"ITEM_UNIT" VARCHAR2(16), 
	"SH_STOCK_CODE" VARCHAR2(16), 
	DISCOUNT NUMBER,
	"COMPANY_NO" NUMBER, 
	 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	"RETRUN_QTY" NUMBER, 
	 CONSTRAINT "PK_SH_INVLINE_NO" PRIMARY KEY ("SH_INVLINE_NO")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "BUS_REGISTRATION" 
   (	"REGISTRATION_ID" NUMBER NOT NULL ENABLE, 
	"REGISTRATION_NO" VARCHAR2(16) NOT NULL ENABLE, 
	"CUSTOMER_NAME" VARCHAR2(50), 
	"PRESENT_ADDRESS" VARCHAR2(100), 
	"MOBILE_NO" VARCHAR2(100), 
	"EMAIL" VARCHAR2(50), 
	"GENDER" VARCHAR2(10), 
	"CUSTOMER_IMAGE" BLOB, 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_REGISTRATION_ID" PRIMARY KEY ("REGISTRATION_NO")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "WMS_SH_PAYMENT" 
   (	"SH_PAYMENT_ID" NUMBER, 
	"SH_MR_NO" VARCHAR2(20), 
	"SH_INVOICE_NO" VARCHAR2(16), 
	"SH_PAYMENT_DATE" DATE, 
	"SH_PAYMENT_PURPOSE" VARCHAR2(30), 
	"SH_PAYMENT_TYPE" VARCHAR2(30), 
	"SH_BILL_AMT" NUMBER, 
	"SH_DISCOUNT_AMT" NUMBER, 
	"SH_VAT_AMT" NUMBER, 
	"SH_PAYABLE_AMT" NUMBER, 
	"SH_CASHPAID_AMT" NUMBER, 
	"CARD_CATEGORY" VARCHAR2(9), 
	"CARD_TYPE" VARCHAR2(9), 
	"CARD_NO" VARCHAR2(30), 
	"OWNER_NAME" VARCHAR2(20), 
	"EXPIRY_DATE" DATE, 
	"CHARGE_AMT" NUMBER, 
	"CARD_AMT" NUMBER, 
	"CARD_STATUS" VARCHAR2(9), 
	"CARD_CHARGE_ID" NUMBER, 
	"SH_REFUND_FLAG" VARCHAR2(1), 
	"SH_REFUND_AGAINST_MRNO" VARCHAR2(16), 
	"SH_REFUND_AMOUNT" NUMBER, 
	"SH_REFUND_REASON" VARCHAR2(50), 
	"SH_REFUND_AUTHORITY" VARCHAR2(30), 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	"COMPANY_NO" NUMBER, 
	 
	"DISCOUNT_BY" VARCHAR2(64), 
	 CONSTRAINT "PK_SH_MR_NO" PRIMARY KEY ("SH_MR_NO")
  USING INDEX  ENABLE
   )
/


CREATE TABLE  "USER_ACCESS" 
   (	"ACCESS_ID" NUMBER NOT NULL ENABLE, 
	"MENU_ID" NUMBER, 
	"USER_NAME" VARCHAR2(200), 
	"ACCESS_TYPE" VARCHAR2(100), 
	"COMPANY_NO" NUMBER, 
	 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(32), 
	"LAST_UPDATED_BY" VARCHAR2(32), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_ACCESS_IS" PRIMARY KEY ("ACCESS_ID")
  USING INDEX  ENABLE
   )
/


CREATE TABLE  "GLOBAL_COMPANY_SETUP" 
   (	"COMPANY_ID" NUMBER, 
	"COMPANY_NO" NUMBER, 
	"COMPANY_NAME" VARCHAR2(100), 
	"ADDRESS" VARCHAR2(300), 
	"PHONE" VARCHAR2(100), 
	"FAX" VARCHAR2(50), 
	"E_MAIL" VARCHAR2(50), 
	"MOBILE" VARCHAR2(50), 
	"LOGO" BLOB, 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"UPDATED_BY" VARCHAR2(16), 
	"UPDATED_ON" DATE, 
	 CONSTRAINT "PK_COMPANY_NO" PRIMARY KEY ("COMPANY_NO")
  USING INDEX  ENABLE
   )
/


CREATE TABLE  "BUS_UNIT_SETUP" 
   (	"UNIT_NO" VARCHAR2(16) NOT NULL ENABLE, 
	"UNIT_NAME" VARCHAR2(100), 
	"DESCRIPTION" VARCHAR2(100), 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"COMPANY_NO" NUMBER, 
	 
	"CREATED_BY" VARCHAR2(10), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(10), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_UNIT_NO" PRIMARY KEY ("UNIT_NO")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "ERP_MAIN_APPLICATION" 
   (	"ID" NUMBER, 
	"PARENT_ID" NUMBER, 
	"APPLICATION_ID" NUMBER, 
	"MENU_ID" NUMBER, 
	"PAGE_NAME" VARCHAR2(200), 
	"PAGE_NUM" NUMBER, 
	"ITEM_NAME" VARCHAR2(4000), 
	"ITEM_VALUE" VARCHAR2(4000), 
	"IMAGE" VARCHAR2(32), 
	"ACTIVE_STATUS" VARCHAR2(1), 
	 CONSTRAINT "PK_ID" PRIMARY KEY ("ID")
  USING INDEX  ENABLE
   )
/

CREATE TABLE  "WMS_ITEM_STOCK" 
   (	"STOCK_ID" NUMBER NOT NULL ENABLE, 
	"STOCK_NO" VARCHAR2(16) NOT NULL ENABLE, 
	"ITEM_NO" VARCHAR2(16) NOT NULL ENABLE, 
	"WSM_CODE" VARCHAR2(16) NOT NULL ENABLE, 
	"OPENING_BALANCE_QNT" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"OPENING_BALANCE_RATE" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"OPENING_BALANCE_DATE" DATE NOT NULL ENABLE, 
	"MRP" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"CURRENT_BALANCE_QNT" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"REORDER_LEVEL" NUMBER DEFAULT 0 NOT NULL ENABLE, 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"COMPANY_NO" NUMBER, 
	"CREATED_BY" VARCHAR2(10), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(10), 
	"LAST_UPDATED_ON" DATE, 
	"CURRENT_PR_RATE" NUMBER, 
	 CONSTRAINT "PK_STOCK_NO" PRIMARY KEY ("STOCK_NO")
  USING INDEX  ENABLE
   )
/


CREATE TABLE  "APP_USERS_LIST" 
   (	"USER_ID" NUMBER NOT NULL ENABLE, 
	"USER_NAME" VARCHAR2(100), 
	"PASSWORD" VARCHAR2(4000), 
	"DEPARTMENT" VARCHAR2(200), 
	"EXPIRES_ON" DATE, 
	"ACCESSCODE" NUMBER, 
	"EMPLOYEE_NO" VARCHAR2(16), 
	"USER_TYPE" VARCHAR2(64), 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"CREATED_ON" DATE, 
	"CREATED_BY" VARCHAR2(32), 
	"LAST_UPDATED_BY" VARCHAR2(32), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_USER_NAME" PRIMARY KEY ("USER_NAME")
  USING INDEX  ENABLE
   )
/


CREATE TABLE  "BUS_PRICE_LIST" 
   (	"PRICE_LINE_NO" NUMBER NOT NULL ENABLE, 
	"PRICE_LIST" NUMBER, 
	"ITEM_NO" VARCHAR2(16), 
	"RATE" NUMBER, 
	"MRP" NUMBER, 
	"BATCH_NO" VARCHAR2(50), 
	"COMPANY_PORTION" NUMBER, 
	"SERVICE_PROVIDER_PORTION" NUMBER, 
	"ACTIVE_STATUS" VARCHAR2(1), 
	"COMPANY_NO" NUMBER, 
	"CREATED_BY" VARCHAR2(16), 
	"CREATED_ON" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(16), 
	"LAST_UPDATED_ON" DATE, 
	 CONSTRAINT "PK_PRICE_LINE_NO" PRIMARY KEY ("PRICE_LINE_NO")
  USING INDEX  ENABLE
   )
/
ALTER TABLE  "GL_STATEMENT" ADD CONSTRAINT "FK_GL_ACCOUNT_NO" FOREIGN KEY ("ACCOUNT_NO")
	  REFERENCES  "CHART_OF_ACCOUNT" ("ACCOUNT_NO") DISABLE
/
ALTER TABLE  "EXPENDITURE_DR" ADD CONSTRAINT "FK_ACCOUNT_NO" FOREIGN KEY ("ACCOUNT_NO")
	  REFERENCES  "CHART_OF_ACCOUNT" ("ACCOUNT_NO") ENABLE
/
ALTER TABLE  "HRM_ADVANCE" ADD CONSTRAINT "FK_EMP_ADV" FOREIGN KEY ("EMPLOYEE_NO")
	  REFERENCES  "HRM_EMPLOYEE_PROFILE" ("EMPLOYEE_NO") ENABLE
/
ALTER TABLE  "HRM_ATTENDANCE" ADD CONSTRAINT "FK_ATT_EMP" FOREIGN KEY ("EMPLOYEE_NO")
	  REFERENCES  "HRM_EMPLOYEE_PROFILE" ("EMPLOYEE_NO") ENABLE
/
ALTER TABLE  "HRM_EMP_WORKING_DAYS" ADD CONSTRAINT "HRM_EMP_WORKING_DAYS_FK" FOREIGN KEY ("EMPLOYEE_NO")
	  REFERENCES  "HRM_EMPLOYEE_PROFILE" ("EMPLOYEE_NO") ENABLE
/
ALTER TABLE  "HRM_SALARY_CAL_DTL" ADD CONSTRAINT "FK_EMP_SCAL" FOREIGN KEY ("EMPLOYEE_NO")
	  REFERENCES  "HRM_EMPLOYEE_PROFILE" ("EMPLOYEE_NO") ENABLE
/
ALTER TABLE  "HRM_SALARY_CAL_DTL" ADD CONSTRAINT "FK_ESALAR" FOREIGN KEY ("SALARY_CALMST_NO")
	  REFERENCES  "HRM_SALARY_CAL_MST" ("SALARY_CALMST_NO") ENABLE
/
ALTER TABLE  "SH_INVLINE" ADD CONSTRAINT "FK_SH_INVOICE_NO" FOREIGN KEY ("SH_INVOICE_NO")
	  REFERENCES  "SH_INVHEADER" ("SH_INVOICE_NO") ENABLE
/
ALTER TABLE  "SH_INVLINE" ADD CONSTRAINT "SH_ITEM_NO" FOREIGN KEY ("ITEM_NO")
	  REFERENCES  "BUS_ITEM_MASTER" ("ITEM_NO") ENABLE
/
ALTER TABLE  "SH_PAYMENT" ADD CONSTRAINT "FK_SH_INVOICE_NO" FOREIGN KEY ("SH_INVOICE_NO")
	  REFERENCES  "SH_INVHEADER" ("SH_INVOICE_NO") DISABLE
/
ALTER TABLE  "SH_SERLINE" ADD CONSTRAINT "SER_ITEM_NO" FOREIGN KEY ("ITEM_NO")
	  REFERENCES  "BUS_ITEM_MASTER" ("ITEM_NO") ENABLE
/
ALTER TABLE  "SH_SERLINE" ADD CONSTRAINT "FK_SH_SERVICE_NO" FOREIGN KEY ("SH_SERVICE_NO")
	  REFERENCES  "SH_SERVICE_MST" ("SH_SERVICE_NO") ENABLE
/
ALTER TABLE  "WMS_SH_PAYMENT" ADD CONSTRAINT "FK_SH_INVOICE_NO" FOREIGN KEY ("SH_INVOICE_NO")
	  REFERENCES  "WMS_SH_INVHEADER" ("SH_INVOICE_NO") ENABLE
/
ALTER TABLE  "WMS_SH_INVLINE" ADD CONSTRAINT "WMS_SH_ITEM_NO" FOREIGN KEY ("ITEM_NO")
	  REFERENCES  "BUS_ITEM_MASTER" ("ITEM_NO") ENABLE
/
ALTER TABLE  "WMS_SH_INVLINE" ADD CONSTRAINT "FK_INVLINE_INVOICE_NO" FOREIGN KEY ("SH_INVOICE_NO")
	  REFERENCES  "WMS_SH_INVHEADER" ("SH_INVOICE_NO") ENABLE
/
ALTER TABLE  "WMS_SH_INVLINE" ADD CONSTRAINT "FK_OPL_STOCK" FOREIGN KEY ("SH_STOCK_CODE")
	  REFERENCES  "WMS_STORE_MST" ("WSM_STORE_NO") ENABLE
/
ALTER TABLE  "CON_PRESCRIPTION_MST" ADD CONSTRAINT "FK_PRESCRIPTION_APPT" FOREIGN KEY ("APPT_NO")
	  REFERENCES  "DR_APPOINTMENT" ("APPT_NO") ENABLE
/
ALTER TABLE  "CON_PRESCRIPTION_MST" ADD CONSTRAINT "FK_PRESCRIPTION_REG" FOREIGN KEY ("REGISTRATION_NO")
	  REFERENCES  "BUS_REGISTRATION" ("REGISTRATION_NO") ENABLE
/
ALTER TABLE  "RECEIVED_CR" ADD CONSTRAINT "FK_RCV_ACCOUNT_NO" FOREIGN KEY ("ACCOUNT_NO")
	  REFERENCES  "CHART_OF_ACCOUNT" ("ACCOUNT_NO") DISABLE
/
ALTER TABLE  "DR_APPOINTMENT" ADD CONSTRAINT "FK_PID" FOREIGN KEY ("PID")
	  REFERENCES  "BUS_REGISTRATION" ("REGISTRATION_NO") ENABLE
/
ALTER TABLE  "EBA_UT_CHART_TASKS" ADD CONSTRAINT "EBA_UT_CHART_TASKS_FK" FOREIGN KEY ("PROJECT")
	  REFERENCES  "EBA_UT_CHART_PROJECTS" ("ID") ON DELETE CASCADE ENABLE
/
ALTER TABLE  "IPD_ADMISSION" ADD CONSTRAINT "FK_IPD_PID" FOREIGN KEY ("REGISTRATION_NO")
	  REFERENCES  "BUS_REGISTRATION" ("REGISTRATION_NO") ENABLE
/
CREATE OR REPLACE FUNCTION  "AMOUNT_IN_WORDS" (p_amount IN Number) RETURN Varchar2 IS
/*****************************************************************************
--Author          :  Bhupinder Singh
--Creation Date   :  05/03/2007
--Purpose         :  This Function returns amount in words.
--Parameters      :
--1) p_amount     :  Only positive and negative values are allowed.
                     Precision can be entered upto 10 digits and only 2 scales
                     are allowed e.g 9999999999.99
-------------------------    MODIFICATION HISTORY ----------------------------
WHO              WHEN(Date)    WHY
Bhupinder Singh  18/01/2007    Created.
-------"-------  05/03/2007    Added CASE statement for positive and negative
                               numbers.
******************************************************************************/
   -------------------------------------
   -- Index by Tables to store word list
   -------------------------------------
   TYPE typ_word_list IS TABLE OF Varchar2(200) INDEX BY BINARY_INTEGER;
   t_typ_word_list typ_word_list;
   TYPE typ_word_gap IS TABLE OF Varchar2(200) INDEX BY BINARY_INTEGER;
   t_typ_word_gap typ_word_gap;
   ------------------
   -- Local Variables
   ------------------
   v_amount        Number := p_amount;
   v_amount_length Number;
   v_words         Varchar2(10000);
   v_point_found   Varchar2(1) := 'N';
   v_point_value   Number;
BEGIN
   /*Getting value after point if found */
   v_point_value := SUBSTR(v_amount,(INSTR(v_amount,'.',1) + 1),2);

   /*Checking whether amount has any scale value also */
   v_point_found := CASE WHEN (INSTR(v_amount,'.',1)) = 0 THEN 'N'
                         WHEN (INSTR(v_amount,'.',1)) > 0 THEN 'Y'
                    END;
   /*Converting amount into pure numeric format */
   v_amount := FLOOR(ABS(v_amount));

   --
   v_amount_length := LENGTH(v_amount);
   --
   t_typ_word_gap(2)  := 'and Paise';
   t_typ_word_gap(3)  := 'Hundred';
   t_typ_word_gap(4)  := 'Thousand';
   t_typ_word_gap(6)  := 'Lakh';
   t_typ_word_gap(8)  := 'Crore';
   t_typ_word_gap(10) := 'Arab';
   --
   FOR i IN 1..99
   LOOP
       t_typ_word_list(i)   :=  To_Char(To_Date(i,'J'),'Jsp');
   END LOOP;
   --
   IF v_amount_length <= 2
   THEN
       /* Conversion 1 to 99 digits */
       v_words := t_typ_word_list(v_amount);
   ELSIF v_amount_length = 3
   THEN
       /* Conversion for 3 digits till 999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,1))||' '||t_typ_word_gap(3);
       IF SUBSTR(v_amount,2,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,2,2));
       END IF;
   ELSIF v_amount_length = 4
   THEN
       /* Conversion for 4 digits till 9999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,1))||' '||t_typ_word_gap(4);
       IF SUBSTR(v_amount,2,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,2,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,3,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,3,2));
       END IF;
   ELSIF v_amount_length = 5
   THEN
       /* Conversion for 5 digits till 99999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,2))||' '||t_typ_word_gap(4);
       IF SUBSTR(v_amount,3,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,3,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,4,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,4,2));
       END IF;

   ELSIF v_amount_length = 6
   THEN
       /* Conversion for 6 digits till 999999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,1))||' '||t_typ_word_gap(6);
       IF SUBSTR(v_amount,2,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,2,2))||' '||t_typ_word_gap(4);
       END IF;
       IF SUBSTR(v_amount,4,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,4,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,5,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,5,2));
       END IF;
   ELSIF v_amount_length = 7
   THEN
       /* Conversion for 7 digits till 9999999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,2))||' '||t_typ_word_gap(6);
       IF SUBSTR(v_amount,3,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,3,2))||' '||t_typ_word_gap(4);
       END IF;
       IF SUBSTR(v_amount,5,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,5,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,6,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,6,2));
       END IF;
   ELSIF v_amount_length = 8
   THEN
       /* Conversion for 8 digits till 99999999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,1))||' '||t_typ_word_gap(8);
       IF SUBSTR(v_amount,2,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,2,2))||' '||t_typ_word_gap(6);
       END IF;
       IF SUBSTR(v_amount,4,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,4,2))||' '||t_typ_word_gap(4);
       END IF;
       IF SUBSTR(v_amount,6,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,6,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,7,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,7,2));
       END IF;
   ELSIF v_amount_length = 9
   THEN
       /* Conversion for 9 digits till 999999999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,2))||' '||t_typ_word_gap(8);
       IF SUBSTR(v_amount,3,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,3,2))||' '||t_typ_word_gap(6);
       END IF;
       IF SUBSTR(v_amount,5,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,5,2))||' '||t_typ_word_gap(4);
       END IF;
       IF SUBSTR(v_amount,7,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,7,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,8,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,8,2));
       END IF;
   ELSIF v_amount_length = 10
   THEN
       /* Conversion for 10 digits till 9999999999 */
       v_words := t_typ_word_list(SUBSTR(v_amount,1,1))||' '||t_typ_word_gap(10);
       IF SUBSTR(v_amount,2,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,2,2))||' '||t_typ_word_gap(8);
       END IF;
       IF SUBSTR(v_amount,4,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,4,2))||' '||t_typ_word_gap(6);
       END IF;
       IF SUBSTR(v_amount,6,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,6,2))||' '||t_typ_word_gap(4);
       END IF;
       IF SUBSTR(v_amount,8,1) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,8,1))||' '||t_typ_word_gap(3);
       END IF;
       IF SUBSTR(v_amount,9,2) != 0
       THEN
           v_words := v_words ||' '||t_typ_word_list(SUBSTR(v_amount,9,2));
       END IF;
   END IF;
   --
   IF v_point_found = 'Y'
   THEN
       IF v_point_value != 0
       THEN
           v_words := v_words||' '||t_typ_word_gap(2)||' '||t_typ_word_list(CASE WHEN LENGTH(SUBSTR(p_amount,(INSTR(p_amount,'.',1) + 1),2)) = 1 THEN SUBSTR(p_amount,(INSTR(p_amount,'.',1) + 1),2)||'0'
                                                                                 WHEN LENGTH(SUBSTR(p_amount,(INSTR(p_amount,'.',1) + 1),2)) = 2 THEN SUBSTR(p_amount,(INSTR(p_amount,'.',1) + 1),2)
                                                                            END);
       END IF;
   END IF;
   --
   IF p_amount < 0
   THEN
       v_words := 'Minus '||v_words;
   ELSIF p_amount = 0
   THEN
       v_words := 'Zero';
   END IF;
   IF LENGTH(v_amount) > 10
   THEN
       v_words := 'Value larger than specified precision allowed to convert into words. Maximum 10 digits allowed for precision.';
   END IF;
   RETURN (v_words);

END amount_in_words;

 
 
/

CREATE OR REPLACE FUNCTION  "FNC_DOCTOR_NAME" (DNO varchar2)
   RETURN VARCHAR2
IS
   V_DR   VARCHAR2(200);
BEGIN
   IF DNO IS NOT NULL
   THEN
      SELECT   DOCTOR_TITLE||'-'||DOCTOR_NAME
        INTO   V_DR
        FROM   BUS_DOCTOR_MASTER
       WHERE   DOCTOR_NO= DNO;
   END IF;

   RETURN V_DR;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_COMPANY_SESSION" (F_SESSION VARCHAR2)
   RETURN NUMBER
IS
   V_COMPANY   NUMBER;
BEGIN
   IF F_SESSION IS NOT NULL
   THEN
      SELECT   COMPANY_NO
        INTO   V_COMPANY
        FROM   GLOBAL_SESSION_GENERATE
       WHERE   SESSION_ID = F_SESSION;
   END IF;

   RETURN V_COMPANY;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_USER_ACCESS" (P_MID varchar2,P_TYPE VARCHAR2 DEFAULT 'Menu',P_USERNAME VARCHAR2 DEFAULT V('APP_USER'))
return    VARCHAR2
IS
MENU_ID NUMBER:=0;
BEGIN
if p_username IN ('ABED','ADMIN') THEN
MENU_ID:=P_MID;
ELSE

IF P_MID IS NOT NULL AND P_TYPE IS NOT NULL AND P_USERNAME IS NOT NULL
   THEN

WITH ABED AS 
(
SELECT U.MENU_ID,E.PARENT_ID FROM erp_main_application E,user_access U
WHERE U.MENU_ID=E.ID AND E.PARENT_ID IS NOT NULL
and USER_NAME=P_USERNAME  AND ACCESS_TYPE=P_TYPE
)
select ID INTO MENU_ID from erp_main_application
where id=p_mid
CONNECT BY prior id= parent_id
start with ID in (select MENU_ID from user_access WHERE USER_NAME=P_USERNAME) 
AND ID NOT IN (SELECT PARENT_ID FROM ABED) 
AND PARENT_ID IS NULL

UNION

select ID from erp_main_application 
WHERE ID in (select menu_id from user_access WHERE USER_NAME=P_USERNAME  AND ACCESS_TYPE=P_TYPE AND MENU_ID=P_MID) 
CONNECT BY prior id= parent_id
start with ID IN (SELECT E.PARENT_ID FROM erp_main_application E,user_access U
WHERE U.MENU_ID=E.ID AND U.USER_NAME=P_USERNAME  AND ACCESS_TYPE=P_TYPE) AND PARENT_ID IS NULL
; 

   END IF;

END IF;

IF P_MID=MENU_ID THEN
   RETURN menu_id  ;
 ELSE
   RETURN NULL;
 END IF;

EXCEPTION
   WHEN NO_DATA_FOUND 
   THEN
      RETURN NULL;
END;

 
/

CREATE OR REPLACE FUNCTION  "FNC_COMPANY_INFO" (CID NUMBER)
   RETURN VARCHAR2
IS
   V_COMPANY   VARCHAR2(200);
BEGIN
   IF CID IS NOT NULL
   THEN
      SELECT   COMPANY_NAME
        INTO   V_COMPANY
        FROM   GLOBAL_COMPANY_SETUP
       WHERE   COMPANY_NO= CID;
   END IF;

   RETURN V_COMPANY;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_CUSTOMER_INFO" (CID varchar2)
   RETURN VARCHAR2
IS
   V_CUSTOMER   VARCHAR2(200);
BEGIN
   IF CID IS NOT NULL
   THEN
      SELECT   CUSTOMER_NAME
        INTO   V_CUSTOMER  
        FROM   BUS_REGISTRATION
       WHERE   REGISTRATION_NO= CID;
   END IF;

   RETURN V_CUSTOMER  ;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_IP_ADDRESS" 
RETURN VARCHAR2
IS
A VARCHAR2(100):=SYS_CONTEXT ('USERENV', 'IP_ADDRESS') ;
B VARCHAR2(100):=OWA_UTIL.GET_CGI_ENV('REMOTE_ADDR');
IP VARCHAR2(100);
BEGIN
IP:=NVL(B,A);
RETURN IP;
END;
/

CREATE OR REPLACE FUNCTION  "FNC_ITEM_NAME" (INO varchar2,P_TYPE VARCHAR2 DEFAULT 'NAME')
   RETURN VARCHAR2
IS
   V_ITEM   VARCHAR2(200);
   V_RATE NUMBER;
   V_CAT VARCHAR2(200);
BEGIN
   IF INO IS NOT NULL
   THEN
      SELECT   ITEM_NAME , ITEM_CATEGORY,
      (SELECT RATE FROM BUS_PRICE_LIST L WHERE L.ITEM_NO= M.ITEM_NO AND NVL(L.ACTIVE_STATUS,'N')='Y') RATE
        INTO   V_ITEM ,V_CAT,V_RATE
        FROM   BUS_ITEM_MASTER M
       WHERE   ITEM_NO= INO;
   END IF;

 IF P_TYPE='NAME' THEN
   RETURN V_ITEM  ;
 ELSIF P_TYPE='RATE' THEN
   RETURN V_RATE ;
 ELSIF P_TYPE='CATEGORY' THEN
   RETURN V_CAT ;
 ELSE
   RETURN 0;
 END IF;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION  "DAYDIFF" (END_DATE TIMESTAMP, START_DATE TIMESTAMP)
RETURN NUMBER
IS 
ABED NUMBER;
V_END_TIME TIMESTAMP;
BEGIN

IF END_DATE IS NULL THEN 
V_END_TIME:=CURRENT_TIMESTAMP;
ELSE
V_END_TIME:=TO_TIMESTAMP(TO_CHAR(END_DATE,'DD-MON-YY HH:MI:SS AM'));
END IF;

SELECT ROUND(CAST(V_END_TIME AS DATE)- CAST(to_timestamp(START_DATE ) AS DATE)) INTO ABED FROM DUAL;


IF (ABED<1) THEN 
   ABED:=1;
END IF;

RETURN ABED;

EXCEPTION WHEN NO_DATA_FOUND
   THEN
      RETURN 10;
END;

 
 
/

CREATE OR REPLACE FUNCTION  "FNC_CUSTOM_HASH" (p_username in varchar2, p_password in varchar2)
return varchar2
is
  l_password varchar2(4000);
  l_salt varchar2(4000) := 'UYUKQULATJYQ2RJTWPTHHIU7K1O7FR';
begin

-- This function should be wrapped, as the hash algorhythm is exposed here.
-- You can change the value of l_salt or the method of which to call the
-- DBMS_OBFUSCATOIN toolkit, but you much reset all of your passwords
-- if you choose to do this.

l_password := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5
  (input_string => p_password || substr(l_salt,10,13) || p_username ||
    substr(l_salt, 4,10)));
return l_password;
end;

 
/

CREATE OR REPLACE FUNCTION  "FNC_BRANCH_SESSION" (F_SESSION VARCHAR2)
   RETURN NUMBER
IS
   V_BRANCH   NUMBER;
BEGIN
   IF F_SESSION IS NOT NULL
   THEN
      SELECT   BRANCH_NO
        INTO   V_BRANCH
        FROM   GLOBAL_SESSION_GENERATE
       WHERE   SESSION_ID = F_SESSION;
   END IF;

   RETURN V_BRANCH;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_ABED_DAYDIFF" (END_DATE TIMESTAMP, START_DATE TIMESTAMP)
RETURN NUMBER
IS 
ABED NUMBER;
V_END_TIME TIMESTAMP;
BEGIN

IF END_DATE IS NULL THEN 
V_END_TIME:=CURRENT_TIMESTAMP;
ELSE
V_END_TIME:=TO_TIMESTAMP(TO_CHAR(END_DATE,'DD-MON-YY HH:MI:SS AM'));
END IF;

SELECT ROUND(CAST(V_END_TIME AS DATE)- CAST(to_timestamp(START_DATE ) AS DATE)) INTO ABED FROM DUAL;


IF (ABED<1) THEN 
   ABED:=1;
END IF;

RETURN ABED;

EXCEPTION WHEN NO_DATA_FOUND
   THEN
      RETURN 10;
END;

 
 
/

CREATE OR REPLACE FUNCTION  "FNC_AMOUNT_INWORDS" (P_AMT       IN NUMBER )                                        
                                                   RETURN VARCHAR2 IS
    M_MAIN_AMT_TEXT      VARCHAR2(2000) ;
    M_TOP_AMT_TEXT       VARCHAR2(2000) ;
    M_BOTTOM_AMT_TEXT    VARCHAR2(2000) ;
    M_DECIMAL_TEXT       VARCHAR2(2000) ;
    M_TOP                NUMBER(20,5) ;
    M_MAIN_AMT           NUMBER(20,5) ;
    M_TOP_AMT            NUMBER(20,5) ;
    M_BOTTOM_AMT         NUMBER(20,5) ;
    M_DECIMAL            NUMBER(20,5) ;
    M_AMT                NUMBER(20,5);
    M_TEXT               VARCHAR2(2000) ;
    BEGIN
       M_MAIN_AMT        := NULL ;
       M_TOP_AMT_TEXT    := NULL ;
       M_BOTTOM_AMT_TEXT := NULL ;
       M_DECIMAL_TEXT    := NULL ;
       
       
       M_DECIMAL    := P_AMT - TRUNC(P_AMT) ;
       
       IF M_DECIMAL >0 THEN
       M_DECIMAL := M_DECIMAL *100;
       END IF;
       
       M_AMT        := TRUNC(P_AMT) ;          
     
     
       M_TOP        := TRUNC(M_AMT / 100000) ;
       M_MAIN_AMT   := TRUNC(M_TOP / 100);
       M_TOP_AMT    := M_TOP - M_MAIN_AMT * 100 ;
       M_BOTTOM_AMT :=  M_AMT - (M_TOP * 100000) ;
     
      IF M_MAIN_AMT > 0 THEN
          M_MAIN_AMT_TEXT := TO_CHAR(TO_DATE(M_MAIN_AMT,'J'),'JSP') ;
          IF M_MAIN_AMT = 1 THEN
            M_MAIN_AMT_TEXT := M_MAIN_AMT_TEXT || ' CRORE ' ;
          ELSE
            M_MAIN_AMT_TEXT := M_MAIN_AMT_TEXT || ' CRORES ' ;
          END IF ;
       END IF ;
     
       IF M_TOP_AMT > 0 THEN
          M_TOP_AMT_TEXT := TO_CHAR(TO_DATE(M_TOP_AMT,'J'),'JSP') ;
          IF M_TOP_AMT = 1 THEN
            M_TOP_AMT_TEXT := M_TOP_AMT_TEXT || ' LAKH ' ;
          ELSE
            M_TOP_AMT_TEXT := M_TOP_AMT_TEXT || ' LAKHS ' ;
          END IF;
       END IF ;
       IF M_BOTTOM_AMT > 0 THEN
          M_BOTTOM_AMT_TEXT := TO_CHAR(TO_DATE(M_BOTTOM_AMT,'J'),'JSP') ;
       END IF ;
       IF M_DECIMAL > 0 THEN
          IF NVL(M_BOTTOM_AMT,0) + NVL(M_TOP_AMT,0) > 0 THEN
             M_DECIMAL_TEXT := ' AND ' || TO_CHAR(TO_DATE(M_DECIMAL,'J'),'JSP') || ' Paisa ' ;
          ELSE
             M_DECIMAL_TEXT :=  TO_CHAR(TO_DATE(M_DECIMAL,'J'),'JSP') ||' Paisa ';
          END IF ;
            END IF ;
       M_TEXT := INITCAP(M_MAIN_AMT_TEXT || M_TOP_AMT_TEXT || M_BOTTOM_AMT_TEXT || ' Taka' || M_DECIMAL_TEXT || ' Only') ;
       M_TEXT := UPPER(SUBSTR(M_TEXT,1,1))|| SUBSTR(M_TEXT,2);
       M_TEXT := 'Received with thanks: '|| M_TEXT;
       RETURN(M_TEXT);
     
    END FNC_AMOUNT_INWORDS;

 
 
/

CREATE OR REPLACE FUNCTION  "FNC_ACCOUNT_NAME" (AID varchar2)
   RETURN VARCHAR2
IS
   V_ACCOUNT   VARCHAR2(200);
BEGIN
   IF AID IS NOT NULL
   THEN
      SELECT   ACCOUNT_NAME
        INTO   V_ACCOUNT
        FROM   CHART_OF_ACCOUNT
       WHERE   ACCOUNT_NO= AID;
   END IF;

   RETURN V_ACCOUNT;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;

 
 
 
/

CREATE OR REPLACE FUNCTION  "FNC_CUSTOM_AUTH" (p_username in VARCHAR2, p_password in VARCHAR2)
return BOOLEAN
is
  l_password varchar2(4000);
  l_stored_password varchar2(4000);
  l_expires_on date;
   t NUMBER;
  l_count number;
begin
t:=0;
select count(*) into l_count from APP_USERS_LIST where user_name = p_username;
if l_count > 0 and t=0 then
  select password, expires_on into l_stored_password, l_expires_on
   from APP_USERS_LIST where user_name = p_username;
  if l_expires_on > sysdate or l_expires_on is null then
    l_password := FNC_CUSTOM_HASH (upper(p_username), p_password);
    if l_password = l_stored_password then
      return true;
    else
      return false;
    end if;
  else
    return false;
end if;
else
  return false;
end if;
end;

 
/

CREATE OR REPLACE FUNCTION  "FNC_EMP_NAME" (ENO varchar2,P_TYPE VARCHAR2 DEFAULT 'NAME')
   RETURN VARCHAR2
IS
   V_NAME   VARCHAR2(200);
BEGIN
   IF ENO IS NOT NULL
   THEN
		SELECT CASE WHEN P_TYPE='NAME' THEN 
		FIRST_NAME||' '||MIDDLE_NAME||' '||LAST_NAME 
		WHEN P_TYPE='NICK' THEN
		NICK_NAME 
		END
		INTO V_NAME 
		FROM HRM_EMPLOYEE_PROFILE 
		WHERE EMPLOYEE_NO=ENO;
   END IF;

   RETURN V_NAME;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 0;
END;
/

CREATE OR REPLACE PACKAGE  "SELECT2" 
AUTHID CURRENT_USER
as
  subtype gt_string is varchar2(32767);

  procedure render (
    p_item   in apex_plugin.t_page_item,
    p_plugin in apex_plugin.t_plugin,
    p_param  in apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result);

  procedure ajax (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_ajax_param,
    p_result in out nocopy apex_plugin.t_item_ajax_result );

  procedure metadata (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_meta_data_param,
    p_result in out nocopy apex_plugin.t_item_meta_data_result );

  function is_displaying_all
  return char;


END select2;
/
CREATE OR REPLACE PACKAGE BODY  "SELECT2" 
AS
gco_min_lov_cols constant number(1) := 2;
gco_max_lov_cols constant number(1) := 3;
gco_lov_display_col constant number(1) := 1;
gco_lov_return_col constant number(1) := 2;
gco_lov_group_col constant number(1) := 3;
gco_contains_ignore_case constant char(3) := 'CIC';
gco_contains_ignore_case_diac constant char(4) := 'CICD';
gco_contains_case_sensitive constant char(3) := 'CCS';
gco_exact_ignore_case constant char(3) := 'EIC';
gco_exact_case_sensitive constant char(3) := 'ECS';
gco_starts_with_ignore_case constant char(3) := 'SIC';
gco_starts_with_case_sensitive constant char(3) := 'SCS';
gco_multi_word constant char(2) := 'MW';


function is_ig(p_item_id number)
return boolean
is
 v_dummy char(1);
begin
 select '1'
 into v_dummy
 from APEX_APPL_PAGE_IG_COLUMNS
 where column_id = p_item_id;

 return true;
exception
  when no_data_found then
     return false;
end is_ig;

procedure print_lov_options(
            p_item in apex_plugin.t_page_item,
            p_plugin in apex_plugin.t_plugin,
            p_value in gt_string default null
          ) is
  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;
  l_select_list_type gt_string := p_item.attribute_01;
  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;
  l_drag_and_drop_sorting gt_string := p_item.attribute_11;
  l_lazy_loading gt_string := p_item.attribute_14;

  lco_null_optgroup_label constant gt_string := 'Ungrouped';

  l_lov apex_plugin_util.t_column_value_list;
  l_null_optgroup gt_string;
  l_tmp_optgroup gt_string;
  l_selected_values apex_application_global.vc_arr2;
  l_display_value gt_string;

  type gt_optgroups
    is table of gt_string
    index by pls_integer;
  laa_optgroups gt_optgroups;

  -- local subprograms
  function optgroup_exists(
             p_optgroups in gt_optgroups,
             p_optgroup in gt_string
           ) return boolean is
    l_index pls_integer := p_optgroups.first;
  begin
    while (l_index is not null) loop
      if p_optgroups(l_index) = p_optgroup then
        return true;
      end if;

      l_index := p_optgroups.next(l_index);
    end loop;

    return false;
  end optgroup_exists;


  function is_selected_value(
             p_value in gt_string,
             p_selected_values in gt_string
           ) return boolean is
    l_selected_values apex_application_global.vc_arr2;
  begin
    l_selected_values := apex_util.string_to_table(p_selected_values);

    for i in 1 .. l_selected_values.count loop
      if apex_plugin_util.is_equal(p_value, l_selected_values(i)) then
        return true;
      end if;
    end loop;

    return false;
  end is_selected_value;
begin
  l_lov := apex_plugin_util.get_data(
             p_sql_statement  => p_item.lov_definition,
             p_min_columns => gco_min_lov_cols,
             p_max_columns => gco_max_lov_cols,
             p_component_name => p_item.name
           );

  -- print the selected LOV options in case of lazy loading or when drag and drop sorting is enabled
  if (l_lazy_loading is not null or l_drag_and_drop_sorting is not null) then
    if p_value is not null then
      l_selected_values := apex_util.string_to_table(p_value);

      for i in 1 .. l_selected_values.count loop
        begin
          l_display_value := apex_plugin_util.get_display_data(
                               p_sql_statement => p_item.lov_definition,
                               p_min_columns => gco_min_lov_cols,
                               p_max_columns => gco_max_lov_cols,
                               p_component_name => p_item.name,
                               p_display_column_no => gco_lov_display_col,
                               p_search_column_no => gco_lov_return_col,
                               p_search_string => l_selected_values(i),
                               p_display_extra => false
                             );
        exception
          when no_data_found then
            l_display_value := null;
        end;

        if not (l_display_value is null and not p_item.lov_display_extra) then
          -- print the display value, or return value if no display value was found
          apex_plugin_util.print_option(
            p_display_value => nvl(l_display_value, l_selected_values(i)),
            p_return_value => l_selected_values(i),
            p_is_selected => true,
            p_attributes => p_item.element_option_attributes,
            p_escape => p_item.escape_output
          );
        end if;
      end loop;
    end if;
  end if;

  if l_lazy_loading is null then
    if l_lov.exists(gco_lov_group_col) then
      if l_null_optgroup_label_cmp is not null then
        l_null_optgroup := l_null_optgroup_label_cmp;
      else
        l_null_optgroup := nvl(l_null_optgroup_label_app, lco_null_optgroup_label);
      end if;

      for i in 1 .. l_lov(gco_lov_display_col).count loop
        l_tmp_optgroup := nvl(l_lov(gco_lov_group_col)(i), l_null_optgroup);

        if not optgroup_exists(laa_optgroups, l_tmp_optgroup) then
          htp.p('<optgroup label="' || l_tmp_optgroup || '">');
          for j in 1 .. l_lov(gco_lov_display_col).count loop
            if nvl(l_lov(gco_lov_group_col)(j), l_null_optgroup) = l_tmp_optgroup then
              apex_plugin_util.print_option(
                p_display_value => l_lov(gco_lov_display_col)(j),
                p_return_value => l_lov(gco_lov_return_col)(j),
                p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(j), p_value),
                p_attributes => p_item.element_option_attributes,
                p_escape => p_item.escape_output
              );
            end if;
          end loop;
          htp.p('</optgroup>');

          laa_optgroups(i) := l_tmp_optgroup;
        end if;
      end loop;
    else
      if (l_drag_and_drop_sorting is not null and p_value is not null) then
        for i in 1 .. l_lov(gco_lov_display_col).count loop
          if not is_selected_value(l_lov(gco_lov_return_col)(i), p_value) then
            apex_plugin_util.print_option(
              p_display_value => l_lov(gco_lov_display_col)(i),
              p_return_value => l_lov(gco_lov_return_col)(i),
              p_is_selected => false,
              p_attributes => p_item.element_option_attributes,
              p_escape => p_item.escape_output
            );
          end if;
        end loop;
      else
        for i in 1 .. l_lov(gco_lov_display_col).count loop
          apex_plugin_util.print_option(
            p_display_value => l_lov(gco_lov_display_col)(i),
            p_return_value => l_lov(gco_lov_return_col)(i),
            p_is_selected => is_selected_value(l_lov(gco_lov_return_col)(i), p_value),
            p_attributes => p_item.element_option_attributes,
            p_escape => p_item.escape_output
          );
        end loop;
      end if;
    end if;
  end if;

  if (p_value is not null and (l_select_list_type = 'TAG' or p_item.lov_display_extra)) then
    if not (l_lazy_loading is not null or l_drag_and_drop_sorting is not null) then
      l_selected_values := apex_util.string_to_table(p_value);

      for i in 1 .. l_selected_values.count loop
        begin
          l_display_value := apex_plugin_util.get_display_data(
                               p_sql_statement => p_item.lov_definition,
                               p_min_columns => gco_min_lov_cols,
                               p_max_columns => gco_max_lov_cols,
                               p_component_name => p_item.name,
                               p_display_column_no => gco_lov_display_col,
                               p_search_column_no => gco_lov_return_col,
                               p_search_string => l_selected_values(i),
                               p_display_extra => false
                             );
        exception
          when no_data_found then
            l_display_value := null;
        end;

        if l_display_value is null then
          apex_plugin_util.print_option(
            p_display_value => l_selected_values(i),
            p_return_value => l_selected_values(i),
            p_is_selected => true,
            p_attributes => p_item.element_option_attributes,
            p_escape => p_item.escape_output
          );
        end if;
      end loop;
    end if;
  end if;
end print_lov_options;

procedure render (
    p_item   in apex_plugin.t_page_item,
    p_plugin in apex_plugin.t_plugin,
    p_param  in apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result)
is
  l_no_matches_msg gt_string := p_plugin.attribute_01;
  l_input_too_short_msg gt_string := p_plugin.attribute_02;
  l_selection_too_big_msg gt_string := p_plugin.attribute_03;
  l_searching_msg gt_string := p_plugin.attribute_04;
  l_null_optgroup_label_app gt_string := p_plugin.attribute_05;
  l_loading_more_results_msg gt_string := p_plugin.attribute_06;
  l_look_and_feel gt_string := p_plugin.attribute_07;
  l_error_loading_msg gt_string := p_plugin.attribute_08;
  l_input_too_long_msg gt_string := p_plugin.attribute_09;
  l_custom_css_path gt_string := p_plugin.attribute_10;
  l_custom_css_filename gt_string := p_plugin.attribute_11;

  l_select_list_type gt_string := p_item.attribute_01;
  l_min_results_for_search gt_string := p_item.attribute_02;
  l_min_input_length gt_string := p_item.attribute_03;
  l_max_input_length gt_string := p_item.attribute_04;
  l_max_selection_size gt_string := p_item.attribute_05;
  l_rapid_selection gt_string := p_item.attribute_06;
  l_select_on_blur gt_string := p_item.attribute_07;
  l_search_logic gt_string := p_item.attribute_08;
  l_null_optgroup_label_cmp gt_string := p_item.attribute_09;
  l_width gt_string := p_item.attribute_10;
  l_drag_and_drop_sorting gt_string := p_item.attribute_11;
  l_token_separators gt_string := p_item.attribute_12;
  l_extra_options gt_string := p_item.attribute_13;
  l_lazy_loading gt_string := p_item.attribute_14;
  l_lazy_append_row_count gt_string := p_item.attribute_15;

  l_display_values apex_application_global.vc_arr2;
  l_multiselect gt_string;

  l_item_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.name);
  l_cascade_parent_items_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.lov_cascade_parent_items);
  l_cascade_items_to_submit_jq gt_string := apex_plugin_util.page_item_names_to_jquery(p_item.ajax_items_to_submit);
  l_items_for_session_state_jq gt_string;
  l_cascade_parent_items apex_application_global.vc_arr2;
  l_optimize_refresh_condition gt_string;

  l_apex_version gt_string;
  l_onload_code gt_string;
  l_render_result apex_plugin.t_page_item_render_result;
  l_is_ig   boolean;

  -- local subprograms
  function get_select2_constructor
  return gt_string is
    l_selected_values apex_application_global.vc_arr2;
    l_display_values apex_application_global.vc_arr2;
    l_json gt_string;
    l_code gt_string;

    l_allow_clear_bool boolean;
    l_rapid_selection_bool boolean;
    l_select_on_blur_bool boolean;
  begin
    if p_item.lov_display_null then
      l_allow_clear_bool := true;
    else
      l_allow_clear_bool := false;
    end if;

    if l_rapid_selection is null then
      l_rapid_selection_bool := true;
    else
      l_rapid_selection_bool := false;
    end if;

    if l_select_on_blur is null then
      l_select_on_blur_bool := false;
    else
      l_select_on_blur_bool := true;
    end if;

    -- make sure the last character of l_extra_options is a comma
    if trim(l_extra_options) is not null then
      if substr(trim(l_extra_options), -1, 1) != ',' then
        l_extra_options := l_extra_options || ',';
      end if;
    end if;

    l_code := '
    $.fn.select2.amd.require(
          [
                "select2/dropdown/attachBody"
          ],
          function (AttachBody) {
                AttachBody.prototype._positionDropdown = (function (originalMethod) {
                        return function () {
                            if ($("td.is-focused").length > 0) {
                              this.$container = $("td.is-focused");
                            }
                            originalMethod.call(this);
                        }
                }(AttachBody.prototype._positionDropdown));
          },
          undefined,
          true
        );

      $("' || l_item_jq || '").select2({' ||
        apex_javascript.add_attribute('placeholder', p_item.lov_null_text, false) ||
        apex_javascript.add_attribute('allowClear', l_allow_clear_bool) ||
        apex_javascript.add_attribute('minimumInputLength', to_number(l_min_input_length)) ||
        apex_javascript.add_attribute('maximumInputLength', to_number(l_max_input_length)) ||
        apex_javascript.add_attribute('minimumResultsForSearch', to_number(l_min_results_for_search)) ||
        apex_javascript.add_attribute('maximumSelectionLength', to_number(l_max_selection_size)) ||
        apex_javascript.add_attribute('closeOnSelect', l_rapid_selection_bool) ||
        apex_javascript.add_attribute('selectOnClose', l_select_on_blur_bool) ||
        apex_javascript.add_attribute('tokenSeparators', l_token_separators) ||
        l_extra_options;

    if l_look_and_feel = 'SELECT2_CLASSIC' then
      l_code := l_code || apex_javascript.add_attribute('theme', 'classic');
    end if;

    l_code := l_code || '"language": {';

    if l_error_loading_msg is not null then
      l_code := l_code || '
        "errorLoading": function() {
                          return "' || l_error_loading_msg || '";
                        },';
    end if;
    if l_input_too_long_msg is not null then
      l_code := l_code || '
        "inputTooLong": function(args) {
                          var msg = "' || l_input_too_long_msg || '";
                          msg = msg.replace("#TERM#", args.input);
                          msg = msg.replace("#MAXLENGTH#", args.maximum);
                          msg = msg.replace("#OVERCHARS#", args.input.length - args.maximum);
                          return msg;
                        },';
    end if;
    if l_input_too_short_msg is not null then
      l_code := l_code || '
        "inputTooShort": function(args) {
                           var msg = "' || l_input_too_short_msg || '";
                           msg = msg.replace("#TERM#", args.input);
                           msg = msg.replace("#MINLENGTH#", args.minimum);
                           msg = msg.replace("#REMAININGCHARS#", args.minimum - args.input.length);
                           return msg;
                         },';
    end if;
    if l_loading_more_results_msg is not null then
      l_code := l_code || '
        "loadingMore": function() {
                         return "' || l_loading_more_results_msg || '";
                       },';
    end if;
    if l_selection_too_big_msg is not null then
      l_code := l_code || '
        "maximumSelected": function(args) {
                             var msg = "' || l_selection_too_big_msg || '";
                             msg = msg.replace("#MAXSIZE#", args.maximum);
                             return msg;
                           },';
    end if;
    if l_no_matches_msg is not null then
      l_code := l_code || '
        "noResults": function() {
                       return "' || l_no_matches_msg || '";
                     },';
    end if;
    if l_searching_msg is not null then
      l_code := l_code || '
        "searching": function() {
                       return "' || l_searching_msg || '";
                     },';
    end if;

    l_code := rtrim(l_code, ',') || '},';

    if l_search_logic != gco_contains_ignore_case then
      case l_search_logic
        when gco_contains_ignore_case_diac then l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;';
        when gco_contains_case_sensitive then l_search_logic := 'return text.indexOf(term) >= 0;';
        when gco_exact_ignore_case then l_search_logic := 'return text.toUpperCase() === term.toUpperCase() || term.length === 0;';
        when gco_exact_case_sensitive then l_search_logic := 'return text === term || term.length === 0;';
        when gco_starts_with_ignore_case then l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) === 0;';
        when gco_starts_with_case_sensitive then l_search_logic := 'return text.indexOf(term) === 0;';
        when gco_multi_word then l_search_logic := '
          var escpTerm = term.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
          return new RegExp(escpTerm.replace(/ /g, ".*"), "i").test(text);';
        else l_search_logic := 'return text.toUpperCase().indexOf(term.toUpperCase()) >= 0;';
      end case;

      l_code := '$.fn.select2.amd.require([''select2/compat/matcher''], function(oldMatcher) {' ||
        l_code || '
        matcher: oldMatcher(
                   function(term, text) {
                     ' || l_search_logic || '
                   }
                 ),';
    end if;
    if l_lazy_loading is not null then
      l_code := l_code || '
        ajax: {
          delay: 400,
          processResults: function(data, params) {
                            var select2Data = $.map(data.row, function(obj) {
                              obj.id = obj.R;
                              obj.text = obj.D;
                              return obj;
                            });

                            return {
                              results: select2Data,
                              pagination: { more: data.more }
                            };
                          },
          cache: true,
          transport: function (params, fSuccess, failure) {
            var promise = apex.server.plugin(
            "' || apex_plugin.get_ajax_identifier || '",
            { pageItems: "'||l_items_for_session_state_jq||'",
              x01: params.data.term,
              x02: params.data.page,
              x03: "LAZY_LOAD"
            },
            { dataType: "json",
              success: fSuccess,
              target : "'||l_item_jq||'"
            });
            return promise;
          }
        },
        escapeMarkup: function(markup) { return markup; },';
    end if;

    if l_select_list_type = 'TAG' then
      l_code := l_code || apex_javascript.add_attribute('tags', true);
    end if;

    l_code := l_code || apex_javascript.add_attribute('width', nvl(l_width, 'element'), true, false);
    l_code := l_code || '})';

    if l_search_logic != gco_contains_ignore_case then
      l_code := l_code || '});';
    else
      l_code := l_code || ';';
    end if;

    -- issue #71: fix focus after selection for single-value items
    if l_select_list_type = 'SINGLE' then
      l_code := l_code || '
        $("' || l_item_jq || '").on(
          "select2:select",
          function(){ $(this).focus(); }
        );';
    end if;

    return l_code;
  end get_select2_constructor;


  function get_sortable_constructor
  return gt_string is
    l_code gt_string;
  begin
    l_code := '
      var s2item = $("' || l_item_jq || '");
      var s2ul = s2item.next(".select2-container").find("ul.select2-selection__rendered");
      s2ul.sortable({
        containment: "parent",
        items: "li:not(.select2-search)",
        tolerance: "pointer",
        stop: function() {
          $(s2ul.find(".select2-selection__choice").get().reverse()).each(function() {
            s2item.prepend(s2item.find(''option[value="'' + $(this).data("data").id + ''"]'')[0]);
          });
        }
      });';

      /* prevent automatic tags sorting
         http://stackoverflow.com/questions/31431197/select2-how-to-prevent-tags-sorting
      s2item.on("select2:select", function(e) {
        var $element = $(e.params.data.element);

        $element.detach();
        $(this).append($element);
        $(this).trigger("change");
      });';
      */

    return l_code;
  end get_sortable_constructor;
begin
  -- GPV
  if apex_application.g_debug then
    apex_plugin_util.debug_page_item(p_plugin, p_item, p_param.value, p_param.is_readonly, p_param.is_printer_friendly);
  end if;
  -- check if select2 is used in Interactive grid
  l_is_ig := is_ig(p_item.id);
  if l_is_ig then
    -- lazy loading should alway be used for interactive grid
    l_lazy_loading := 'Y';
    l_width := '100%';
  end if;

  <<readonly>>
  if (p_param.is_readonly or p_param.is_printer_friendly) then
    apex_plugin_util.print_hidden_if_readonly(p_item.name, p_param.value, p_param.is_readonly, p_param.is_printer_friendly);

    begin
      l_display_values := apex_plugin_util.get_display_data(
                            p_sql_statement => p_item.lov_definition,
                            p_min_columns => gco_min_lov_cols,
                            p_max_columns => gco_max_lov_cols,
                            p_component_name => p_item.name,
                            p_search_value_list => apex_util.string_to_table(p_param.value),
                            p_display_extra => p_item.lov_display_extra
                          );
    exception
      when no_data_found then
        null; -- https://github.com/nbuytaert1/apex-select2/issues/51
    end;

    if l_display_values.count = 1 then
      apex_plugin_util.print_display_only(
        p_item_name => p_item.name,
        p_display_value => l_display_values(1),
        p_show_line_breaks => false,
        p_escape => p_item.escape_output,
        p_attributes => p_item.element_attributes
      );
    elsif l_display_values.count > 1 then
      htp.p('
        <ul id="' || p_item.name || '_DISPLAY"
          class="display_only ' || p_item.element_css_classes || '"' ||
          p_item.element_attributes || '>');

      for i in 1 .. l_display_values.count loop
        if p_item.escape_output then
          htp.p('<li>' || htf.escape_sc(l_display_values(i)) || '</li>');
        else
          htp.p('<li>' || l_display_values(i) || '</li>');
        end if;
      end loop;

      htp.p('</ul>');
    end if;

  end if; -- readolnly


  apex_javascript.add_library(
    p_name => 'select2.full.min',
    p_directory => p_plugin.file_prefix,
    p_version => null
  );
  apex_javascript.add_library(
    p_name => 'select2-apex',
    p_directory => p_plugin.file_prefix,
    p_version => null
  );
  apex_css.add_file(
    p_name => 'select2.min',
    p_directory => p_plugin.file_prefix,
    p_version => null
  );
  if l_look_and_feel = 'SELECT2_CLASSIC' then
    apex_css.add_file(
      p_name => 'select2-classic',
      p_directory => p_plugin.file_prefix,
      p_version => null
    );
  elsif l_look_and_feel = 'CUSTOM' then
    apex_css.add_file(
      p_name => apex_plugin_util.replace_substitutions(l_custom_css_filename),
      p_directory => apex_plugin_util.replace_substitutions(l_custom_css_path),
      p_version => null
    );
  end if;

  if l_select_list_type in ('MULTI', 'TAG') then
    l_multiselect := 'multiple="multiple"';
  end if;

  htp.p('
    <select ' || l_multiselect || '
      id="' || p_item.name || '"
      name="' || apex_plugin.get_input_name_for_page_item(true) || '"
      class="selectlist ' || p_item.element_css_classes || '"' ||
      p_item.element_attributes || '>');

  if (l_select_list_type = 'SINGLE' and p_item.lov_display_null) then
    apex_plugin_util.print_option(
      p_display_value => p_item.lov_null_text,
      p_return_value => p_item.lov_null_value,
      p_is_selected => false,
      p_attributes => p_item.element_option_attributes,
      p_escape => p_item.escape_output
    );
  end if;

  print_lov_options(p_item, p_plugin, p_param.value);

  htp.p('</select>');

  -- init l_items_for_session_state_jq used in get_select2_constructor
  if p_item.lov_cascade_parent_items is not null then
    l_items_for_session_state_jq := l_cascade_parent_items_jq;

    if l_cascade_items_to_submit_jq is not null then
      l_items_for_session_state_jq := l_items_for_session_state_jq || ',' || l_cascade_items_to_submit_jq;
    end if;
  end if;

  l_onload_code := get_select2_constructor;

  <<drag_and_drop_sorting>>
  if l_drag_and_drop_sorting is not null then
    select substr(version_no, 1, 3)
    into l_apex_version
    from apex_release;

    if l_apex_version = '4.2' then
      apex_javascript.add_library(
        p_name => 'jquery.ui.sortable.min',
        p_directory => '#JQUERYUI_DIRECTORY#ui/minified/',
        p_version => null
      );
    else
      apex_javascript.add_library(
        p_name => 'jquery.ui.sortable.min',
        p_directory => '#IMAGE_PREFIX#libraries/jquery-ui/1.10.4/ui/minified/',
        p_version => null
      );
    end if;

    l_onload_code := l_onload_code || get_sortable_constructor();
  end if;--drag_and_drop_sorting

  <<lov_cascade_parent_items>>
  if p_item.lov_cascade_parent_items is not null then
    l_onload_code := l_onload_code || '
      $("' || l_cascade_parent_items_jq || '").on("change", function(e) {';

    if p_item.ajax_optimize_refresh then
      l_cascade_parent_items := apex_util.string_to_table(l_cascade_parent_items_jq, ',');

      l_optimize_refresh_condition := '$("' || l_cascade_parent_items(1) || '").val() === ""';

      for i in 2 .. l_cascade_parent_items.count loop
        l_optimize_refresh_condition := l_optimize_refresh_condition || ' || $("' || l_cascade_parent_items(i) || '").val() === ""';
      end loop;

      l_onload_code := l_onload_code || '
        var item = $("' || l_item_jq || '");
        if (' || l_optimize_refresh_condition || ') {
          item.val("").trigger("change");
        } else {';
    end if;
    l_onload_code := l_onload_code || '
          var valBeforeRefresh = $v("' || ltrim(l_item_jq,'#')||'");
          $s("' || ltrim(l_item_jq,'#') || '",valBeforeRefresh);';
    if p_item.ajax_optimize_refresh then
      l_onload_code := l_onload_code || '}';
    end if;

    l_onload_code := l_onload_code || '});';
  end if; --lov_cascade_parent_items

  l_onload_code := l_onload_code || '
      beCtbSelect2.events.bind("' || l_item_jq || '");';

  --if l_is_ig then
    -- do not use l_cascade_parent_items_jq in IG
    --l_onload_code := l_onload_code || '
      --    beCtbSelect2.main.initSelect2("' || l_item_jq || '",'||'"'|| apex_plugin.get_ajax_identifier||'","'||l_lazy_loading||'","'||l_select_list_type||'");';
  --else
    l_onload_code := l_onload_code || '
          beCtbSelect2.main.initSelect2("' || l_item_jq || '",'||'"'|| apex_plugin.get_ajax_identifier||'","'||l_lazy_loading||'","'||l_select_list_type||'","'||l_items_for_session_state_jq||'");';
  --end if;

  apex_javascript.add_onload_code(l_onload_code);
  l_render_result.is_navigable := true;
end render;

--https://ddoracle.blogspot.co.at/2006/11/print-clob-to-web.html
procedure HtpPrn(pclob in clob) is
 v_excel varchar2(32000);
 v_clob clob := pclob;
begin
  while length(v_clob) > 0 loop
    begin
      if length(v_clob) > 16000 then
         v_excel:= substr(v_clob,1,16000);
         htp.prn(v_excel);
         v_clob:= substr(v_clob,length(v_excel)+1);
      else
         v_excel := v_clob;
         htp.prn(v_excel);
         v_clob:='';
         v_excel := '';
      end if;
    end;
  end loop;
end;

procedure ajax (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_ajax_param,
    p_result in out nocopy apex_plugin.t_item_ajax_result )
is
  l_select_list_type gt_string := p_item.attribute_01;
  l_search_logic gt_string := p_item.attribute_08;
  l_lazy_append_row_count gt_string := p_item.attribute_15;

  l_lov apex_plugin_util.t_column_value_list;
  --l_json gt_string;
  l_json gt_string;
  l_apex_plugin_search_logic gt_string;
  l_search_string gt_string;
  l_search_page number;
  l_first_row number;
  l_loop_count number;
  l_more_rows_boolean boolean;

  l_result apex_plugin.t_page_item_ajax_result;

  procedure get_data_by_id(p_delimetered_id_list in varchar2)
  is
    v_display_values    apex_application_global.vc_arr2;
    v_id_list           apex_application_global.vc_arr2;
    v_filtered_id_list  apex_application_global.vc_arr2;
  begin
    v_id_list := apex_util.string_to_table(p_delimetered_id_list,nvl(p_item.attribute_13,':'));

    v_filtered_id_list := APEX_PLUGIN_UTIL.GET_DISPLAY_DATA (
         p_sql_statement     => p_item.lov_definition,
         p_min_columns       => gco_min_lov_cols,
         p_max_columns       => gco_max_lov_cols,
         p_component_name    => p_item.name,
         p_display_column_no => gco_lov_return_col,
         p_search_column_no  => gco_lov_return_col,
         p_search_value_list => v_id_list,
         p_display_extra     => false); -- external values should be displayed only on page load - not when user change a value
         --p_item.lov_display_extra

    v_display_values := APEX_PLUGIN_UTIL.GET_DISPLAY_DATA (
         p_sql_statement     => p_item.lov_definition,
         p_min_columns       => gco_min_lov_cols,
         p_max_columns       => gco_max_lov_cols,
         p_component_name    => p_item.name,
         p_display_column_no => gco_lov_display_col,
         p_search_column_no  => gco_lov_return_col,
         p_search_value_list => v_filtered_id_list,
         p_display_extra     => false);
   l_json := '[';
   for i in 1..v_display_values.count loop
        l_json := l_json ||
          '{' ||
             apex_javascript.add_attribute('R', v_filtered_id_list(i), false, true) ||
             apex_javascript.add_attribute('D', sys.htf.escape_sc(v_display_values(i)), false, false) ||
          '},';
   end loop;
   l_json := rtrim(l_json,',')||']';
  end get_data_by_id;

begin
  if apex_application.g_x06 = 'GETDATA' then
      get_data_by_id(apex_application.g_x04);
      sys.htp.p(nvl(l_json,' '));
  elsif apex_application.g_x03 = 'LAZY_LOAD' then
    l_search_string := nvl(apex_application.g_x01, '%');
    l_search_page := nvl(apex_application.g_x02, 1);
    l_first_row := ((l_search_page - 1) * nvl(l_lazy_append_row_count, 0)) + 1;

    -- translate Select2 search logic into APEX_PLUGIN_UTIL search logic
    -- the percentage wildcard returns all rows whenever the search string is null
    case l_search_logic
      when gco_contains_case_sensitive then
        l_apex_plugin_search_logic := apex_plugin_util.c_search_like_case; -- uses LIKE %value%
      when gco_exact_ignore_case then
        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER (not completely correct)
      when gco_exact_case_sensitive then
        l_apex_plugin_search_logic := apex_plugin_util.c_search_lookup; -- uses = value
      when gco_starts_with_ignore_case then
        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_ignore; -- uses LIKE VALUE% with UPPER
      when gco_starts_with_case_sensitive then
        l_apex_plugin_search_logic := apex_plugin_util.c_search_exact_case; -- uses LIKE value%
      else
        l_apex_plugin_search_logic := apex_plugin_util.c_search_like_ignore; -- uses LIKE %VALUE% with UPPER
    end case;

    if l_search_logic = gco_multi_word then
      l_search_string := replace(l_search_string, ' ', '%');
    end if;
    l_lov := apex_plugin_util.get_data(
               p_sql_statement => p_item.lov_definition,
               p_min_columns => gco_min_lov_cols,
               p_max_columns => gco_max_lov_cols,
               p_component_name => p_item.name,
               p_search_type => l_apex_plugin_search_logic,
               p_search_column_no => gco_lov_display_col,
               p_search_string => apex_plugin_util.get_search_string(
                                    p_search_type => l_apex_plugin_search_logic,
                                    p_search_string => l_search_string
                                  ),
               p_first_row => l_first_row,
               p_max_rows => l_lazy_append_row_count + 1
             );
    if l_lov(gco_lov_return_col).count = l_lazy_append_row_count + 1 then
      l_loop_count := l_lov(gco_lov_return_col).count - 1;
    else
      l_loop_count := l_lov(gco_lov_return_col).count;
    end if;

    apex_json.initialize_clob_output;
    apex_json.open_object;
    apex_json.open_array('row');

    if p_item.escape_output then
      for i in 1 .. l_loop_count loop
        apex_json.open_object;
        apex_json.write('R',htf.escape_sc(l_lov(gco_lov_return_col)(i)));
        apex_json.write('D',htf.escape_sc(l_lov(gco_lov_display_col)(i)));
        apex_json.close_object;
      end loop;
    else
      for i in 1 .. l_loop_count loop
        apex_json.open_object;
        apex_json.write('R',l_lov(gco_lov_return_col)(i));
        apex_json.write('D',l_lov(gco_lov_display_col)(i));
        apex_json.close_object;
      end loop;
    end if;

    if l_lov(gco_lov_return_col).exists(l_lazy_append_row_count + 1) then
      l_more_rows_boolean := true;
    else
      l_more_rows_boolean := false;
    end if;
    apex_json.close_array;
    apex_json.write('more',l_more_rows_boolean);
    apex_json.close_all;
    HtpPrn(apex_json.get_clob_output);
    apex_json.free_output;
  else
    print_lov_options(p_item, p_plugin);
  end if;
end ajax;

procedure metadata (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_meta_data_param,
    p_result in out nocopy apex_plugin.t_item_meta_data_result )
is
begin
    p_result.is_multi_value := true;
end metadata;

function is_displaying_all
return char
is
begin
  if apex_application.g_x06 = 'GETDATA' then
    return 'Y';
  else
   return 'N';
  end if;
end is_displaying_all;

END select2;
/

CREATE OR REPLACE PROCEDURE  "SHOW_HTML_FROM_URL" (p_url  IN  VARCHAR2,
                                                p_username IN VARCHAR2 DEFAULT NULL,
                                                p_password IN VARCHAR2 DEFAULT NULL) AS
  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_text           VARCHAR2(32767);
BEGIN
  -- Make a HTTP request and get the response.
  UTL_HTTP.set_detailed_excp_support (TRUE);
  l_http_request  := UTL_HTTP.begin_request(p_url);

  -- Use basic authentication if required.
  IF p_username IS NOT NULL and p_password IS NOT NULL THEN
    UTL_HTTP.set_authentication(l_http_request, p_username, p_password);
  END IF;

  l_http_response := UTL_HTTP.get_response(l_http_request);

  -- Loop through the response.
  BEGIN
    LOOP
      UTL_HTTP.read_text(l_http_response, l_text, 32766);
      DBMS_OUTPUT.put_line (l_text);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
  END;
EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    RAISE;
END show_html_from_url;

 
 
 
/

CREATE OR REPLACE PROCEDURE  "PRC_INPUT_SEQID" (P_SEQ IN VARCHAR2, P_TID OUT NUMBER  )
IS
V_ID NUMBER ;
SEQ_NAME    VARCHAR2(1000);

BEGIN

  IF P_SEQ IS NOT NULL THEN
      SEQ_NAME := 'select ' || P_SEQ || '.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE SEQ_NAME INTO V_ID ;

      P_TID:=V_ID;

  END IF;

EXCEPTION
     WHEN OTHERS   THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

 
 
 
/

CREATE OR REPLACE PROCEDURE  "PRC_CB_SESSION" (F_SESSION IN VARCHAR2,V_COMPANY OUT NUMBER,V_BRANCH OUT NUMBER)
IS
 --  V_COMPANY   NUMBER;
 --  V_BRANCHNUMBER;
   CURSOR CB_SESSION IS SELECT   COMPANY_NO,BRANCH_NO FROM   GLOBAL_SESSION_GENERATE  WHERE   SESSION_ID = F_SESSION;
BEGIN
FOR CB IN CB_SESSION
LOOP
   IF CB.COMPANY_NO IS NOT NULL AND CB.BRANCH_NO IS NOT NULL THEN
    V_COMPANY:=CB.COMPANY_NO;
V_BRANCH:=CB.BRANCH_NO;
   END IF;
END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
    RAISE;
END;

 
 
 
/

CREATE OR REPLACE PROCEDURE  "PRC_INPUT_DU" (P_DATE OUT DATE,P_USER OUT VARCHAR2)
IS
BEGIN
    P_DATE:=SYSDATE;
    P_USER:=UPPER(V('APP_USER'));
EXCEPTION
    WHEN OTHERS THEN NULL;
END;

 
 
 
/

CREATE OR REPLACE PROCEDURE  "PRC_HRM_SALARY" (P_MONTH IN VARCHAR2,P_TYPE VARCHAR2)
IS
	V_DAY NUMBER:=0;
	V_HOLIDAY NUMBER:=0;
	V_WORKING_DAY NUMBER:=0;
	V_LEAVE_DAY NUMBER:=0;
	V_OFF_DAY NUMBER:=0;
	V_CHECK_EMP NUMBER:=0;
	V_WD HRM_EMP_WORKING_DAYS%ROWTYPE;
	V_SAL_M NUMBER;
	V_SAL_MST NUMBER:=0;
	V_ADV NUMBER;
	V_DEDUCT NUMBER:=0;
	V_ERROR EXCEPTION;
	V_MSG VARCHAR2(255);
    V_LDAY NUMBER;
	
	
	CURSOR EMP IS SELECT EMPLOYEE_NO,NVL(SALARY_CASH_PERCENT,(SALARY_BANK_PERCENT*60)) SALARY,NVL(TO_CHAR((SALARY_CASH_PERCENT)/30,'99.99') ,
					   SALARY_BANK_PERCENT) SAL_DAY 
					   FROM HRM_EMPLOYEE_PROFILE 
					   WHERE NVL(ACTIVE_STATUS,'N')='Y';
			   


BEGIN

IF P_MONTH IS NULL OR P_TYPE IS NULL THEN
		V_MSG :='<img src="#IMAGE_PREFIX#alert_warning.gif" alt=""> Invalid Parameters !';
		RAISE V_ERROR;
ELSE

	IF P_TYPE='GENERATE_WORKING_DAY' THEN

			SELECT COUNT(SALARY_CALMST_NO) INTO V_SAL_MST FROM HRM_SALARY_CAL_MST WHERE SELECT_MONTH=P_MONTH;

		IF V_SAL_MST>0 THEN

				V_MSG :='<img src="#IMAGE_PREFIX#alert_warning.gif" alt=""> Salary Already Generated !';
				RAISE V_ERROR;

	else


		BEGIN
		delete FROM HRM_EMP_WORKING_DAYS WHERE SALARY_MONTH=P_MONTH;
		COMMIT;
		END;


	select
 	--  COUNT(to_date(TO_DATE(P_MONTH,'Mon-YY'),'MM/DD/yyyy') + lvl) INTO V_DAY         WORKING PL/SQL COMMAND LINE
 
	 COUNT(to_date(TO_DATE(P_MONTH,'Mon-YY'),'DD-MON-YY') + lvl) INTO V_DAY --FOR APEX

	from
   		(select level - 1 lvl
    			from
      				dual
    			connect by
  		 level <= (trunc(last_day(to_date(P_MONTH,'Mon-YY'))) - trunc(last_day(add_months(trunc(TO_DATE(P_MONTH,'Mon-YY')),-1))+1))+ 1);


   		select count(*) into v_off_day from holiday_setup where to_char(HOLIDAY,'MON-YY')=P_MONTH and HOLIDAY_TYPE='PUBLIC';
    	select count(*) into v_holiday from holiday_setup where to_char(HOLIDAY,'MON-YY')=P_MONTH and HOLIDAY_TYPE <> 'PUBLIC';

    if V_DAY=31 THEN
    V_LDAY:=31;
    v_day:=30;
    else
    v_day:=v_day;
    end if;


FOR A IN EMP

LOOP
SELECT COUNT(*) INTO V_CHECK_EMP FROM HRM_EMP_WORKING_DAYS WHERE SALARY_MONTH=P_MONTH AND EMPLOYEE_NO=A.EMPLOYEE_NO;
	IF V_CHECK_EMP<1 THEN 
	select
	--count(  to_date(TO_DATE(P_MONTH,'Mon-YY'),'MM/DD/yyyy') + lvl ) INTO V_WORKING_DAY
	
	 COUNT(to_date(TO_DATE(P_MONTH,'Mon-YY'),'DD-MON-YY') + lvl) INTO V_WORKING_DAY --FOR APEX
	from
   (select level - 1 lvl
    from
      dual
    connect by
   level <= (trunc(last_day(to_date(P_MONTH,'Mon-YY'))) - trunc(last_day(add_months(trunc(TO_DATE(P_MONTH,'Mon-YY')),-1))+1))+ 1)
	V where
   (to_date(TO_DATE(P_MONTH,'Mon-YY'),'DD-MON-YY') + lvl) not in (select holiday from HOLIDAY_SETUP WHERE MONTH_NAME=P_MONTH AND HOLIDAY_TYPE <>'PUBLIC') 
 AND (to_date(TO_DATE(P_MONTH,'Mon-YY'),'DD-MON-YY') + lvl) in (select attendance_date from hrm_attendance where employee_no=A.EMPLOYEE_NO AND TO_CHAR (ATTENDANCE_DATE,'MON-YY')=P_MONTH) 
   order by 1;  


IF V_LDAY=31 THEN
    V_WORKING_DAY:=V_WORKING_DAY-1;
ELSE
V_WORKING_DAY:=V_WORKING_DAY;
END IF;


	INSERT INTO HRM_EMP_WORKING_DAYS (EMPLOYEE_NO, SALARY_MONTH,WORKING_DAY,LEAVE,OFF_DAY,HOLIDAY,SYSTEM_WORKING_DAY,ACTIVE_STATUS) 
	VALUES	(A.EMPLOYEE_NO,P_MONTH,(V_DAY-v_OFF_DAY-V_HOLIDAY),(V_DAY-(V_WORKING_DAY+V_HOLIDAY)-V_OFF_DAY),V_OFF_DAY,V_HOLIDAY,
    (V_WORKING_DAY+V_OFF_DAY),
    'Y');
V_WORKING_DAY:=0;
	END IF;

END LOOP;

	end if;
END IF;

IF P_TYPE='GENERATE_SALARY' THEN  
	V_SAL_MST:=0;
	
		SELECT COUNT(SALARY_CALMST_NO) INTO V_SAL_MST FROM HRM_SALARY_CAL_MST WHERE SELECT_MONTH=P_MONTH and nvl(APPROVE_FLAG,'N')='Y';
	IF V_SAL_MST>0 THEN

				V_MSG :='<img src="#IMAGE_PREFIX#alert_warning.gif" alt=""> Salary Already Generated !';
				RAISE V_ERROR;
	else
		BEGIN
		SELECT COUNT(SALARY_CALMST_NO) INTO V_SAL_MST FROM HRM_SALARY_CAL_MST WHERE SELECT_MONTH=P_MONTH;
		delete FROM HRM_SALARY_CAL_DTL WHERE SALARY_CALMST_NO=(SELECT SALARY_CALMST_NO FROM HRM_SALARY_CAL_MST WHERE SELECT_MONTH=P_MONTH);
		COMMIT;
        delete FROM HRM_SALARY_CAL_MST WHERE SELECT_MONTH=P_MONTH;
        commit;
		EXCEPTION WHEN NO_DATA_FOUND THEN
		V_SAL_MST:=0;
		END;

 IF V_SAL_MST<1 THEN
	SELECT NVL(MAX(SALARY_CALMST_NO)+1,1) 
	INTO 
	V_SAL_M 
	FROM HRM_SALARY_CAL_MST;
 INSERT 
	INTO 
		HRM_SALARY_CAL_MST (SALARY_CALMST_NO,SELECT_MONTH,SAL_DATE,TOTAL_AMOUNT,ACTIVE_STATUS) VALUES (V_SAL_M,P_MONTH,SYSDATE,0,'Y');

	FOR A IN EMP
	loop
		SELECT 
					*
					INTO V_WD
					FROM HRM_EMP_WORKING_DAYS 
					WHERE SALARY_MONTH=P_MONTH 
					AND EMPLOYEE_NO=A.EMPLOYEE_NO;
	
	BEGIN
	
	SELECT ADVANCE_NO,
		CASE WHEN ADVANCE_BALANCE<DEDUCT_AMT THEN
		ADVANCE_BALANCE
		ELSE
		DEDUCT_AMT
		END AS DEDUCT
		INTO V_ADV,V_DEDUCT
		FROM HRM_ADVANCE
	WHERE ADVANCE_BALANCE>0
		AND EMPLOYEE_NO=A.EMPLOYEE_NO
		AND NVL(ACTIVE_STATUS,'N')='Y';
	EXCEPTION WHEN NO_DATA_FOUND THEN
	V_ADV:=NULL;
	V_DEDUCT:=0;
	END;
		INSERT INTO HRM_SALARY_CAL_DTL(SALARY_CALMST_NO,
										EMPLOYEE_NO,
										SALARY,
										PAY_SALARY,
										BONUS,
										ADVANCE_NO,
										ADVANCE_AMT,
									   MEDICAL_ALLOW,
									  ACTIVE_STATUS) 
										VALUES
										(V_SAL_M,
										A.EMPLOYEE_NO,
										A.SALARY,
										((A.SAL_DAY)*(V_WD.SYSTEM_WORKING_DAY)),
										0,
										V_ADV,
										V_DEDUCT,
										 0,
										'Y');
										
	
		COMMIT;
	end loop;
	
 end if;
  END IF;
 
END IF;

END IF;
EXCEPTION WHEN V_ERROR THEN
apex_application.g_print_success_message :=V_MSG ;
     WHEN OTHERS THEN  raise;
     
      --V_MSG:=SUBSTR(SQLERRM, 1 , 64);
--                apex_application.g_print_success_message :=V_MSG ;
--                ROLLBACK;

END;
/

 CREATE SEQUENCE   "WSM_STORE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 12 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ACCOUNT_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 13 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "APP_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 161 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ATTENDANCE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "BRANCH_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "DETAILS_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 2147 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "EMP_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 8000 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_PAYMENT_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 50 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "INVOICE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ITEM_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 153 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "GL_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 10 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_PAYMENT_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 79610 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "STOCK_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1687 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SUP_BILL_DTLS_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ODETAILS_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1873 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ORDER_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 473 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRICE_LINE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 283 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "BRANCH_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 6 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "COMPANY_NO_QEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SL_OB_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 61 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_SERLINE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "INVOICE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ORDER_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 473 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVLINE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 165017 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ACCOUNT_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 13 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "COMPANY_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "EMPLOYEE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 132 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "EXPENDITURE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "RECEIVED_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 10 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ATTENDANCE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_MR_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 3620 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PODETAILS_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1943 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "REQUISITION_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 484 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PO_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 478 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVLINE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7311 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "COMPANY_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 7 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ITEM_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 153 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "IPD_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 13 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "APPT_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "ITEM_no_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRESCRIPTION_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVOICE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 21 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVOICE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 15 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "REGISTRATION_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 172 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "DOCTOR_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 9 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "EXPENDITURE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_MR_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 79610 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SESSION_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4689 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SUB_BILL_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 141 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "BILL_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 121 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_SERVICE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 52 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "REQUISITION_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 469 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "WSM_STORE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 12 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "EMPLOYEE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 31 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVOICE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 52856 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "PRICE_LIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 8 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "RECEIVED_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 10 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "STOCK_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1687 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SH_INVOICE_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 52845 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "REGISTRATION_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 173 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "SUPPLIER_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 20 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "DEPT_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "DESIGNATION_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "HED_DEGREE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "HRM_EMP_WORKING_DAY_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1181 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
 CREATE SEQUENCE   "HRM_ATTENDANCE_NO_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 3641 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL
/
CREATE OR REPLACE TRIGGER  "WSM_STOCK_TRG" 
   BEFORE INSERT OR UPDATE OR DELETE   ON WMS_ITEM_STOCK
   FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;



      IF :NEW.STOCK_ID IS NULL
      THEN
     PRC_INPUT_SEQID('STOCK_ID_SEQ',:NEW.STOCK_ID);

      END IF;

      IF :NEW.STOCK_NO IS NULL
      THEN
     PRC_INPUT_SEQID('STOCK_NO_SEQ',ID_INPUT);

     :NEW.STOCK_NO:='STK'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;







/
ALTER TRIGGER  "WSM_STOCK_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "DR_APPOINTMENT_TRG" 
   BEFORE INSERT OR UPDATE ON DR_APPOINTMENT
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
   IF INSERTING
   THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

      IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
       PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;


   IF :NEW.APPT_NO IS NULL
       THEN
       PRC_INPUT_SEQID('APPT_NO_SEQ',ID_INPUT);
       :NEW.APPT_NO:='AP'||LPAD(ID_INPUT,6,0);
       END IF;

      IF :NEW.ARRIVED_FLAG IS NOT NULL
      THEN
         :new.ARRIVED_TIME := SYSDATE;
      END IF;


      IF :NEW.DR_IN_flag IS NOT NULL
      THEN
         :new.DRIN_TIME := SYSDATE;
      END IF;

   ELSIF UPDATING
   THEN
       IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;


  if NVL(:NEW.ARRIVED_FLAG,'N') = 'Y' AND NVL(:OLD.ARRIVED_FLAG,'N') = 'N' then
         :new.ARRIVED_TIME := SYSDATE;
      END IF;


      if NVL(:NEW.DR_IN_FLAG,'N') = 'Y' AND NVL(:OLD.DR_IN_FLAG,'N') = 'N' then
         :new.DRIN_TIME := SYSDATE;
      END IF;

      if NVL(:NEW.DR_OUT_FLAG,'N') = 'Y' AND NVL(:OLD.DR_OUT_FLAG,'N') = 'N' then
         :new.DROUT_TIME := SYSDATE;
      END IF;


      IF :NEW.APPT_CLOSE_FLAG IS NOT NULL
      THEN
         :new.APPTCLOSE_TIME := SYSDATE;
         :NEW.STATUS:='Closed';

         END IF;

       IF :NEW.STATUS='Closed'  THEN

         :new.APPTCLOSE_TIME := SYSDATE;
         :NEW.APPT_CLOSE_FLAG:='Y';

         END IF;

         END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END;





/
ALTER TRIGGER  "DR_APPOINTMENT_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "APP_USERS_LIST_TRG" 
  BEFORE INSERT OR UPDATE ON APP_USERS_LIST
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;
      
     :NEW.USER_NAME:=UPPER(:NEW.USER_NAME);


 IF :NEW.USER_ID IS NULL
     THEN

     SELECT NVL(MAX(USER_ID)+1,1) INTO :NEW.USER_ID FROM APP_USERS_LIST;

      END IF;
      
       IF :NEW.USER_NAME IS NOT NULL AND :NEW.PASSWORD IS NOT NULL 
     THEN

     SELECT FNC_CUSTOM_HASH(:NEW.USER_NAME,:NEW.PASSWORD) INTO :NEW.PASSWORD FROM DUAL;

      END IF;

   ELSIF UPDATING
   THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;




/
ALTER TRIGGER  "APP_USERS_LIST_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "CON_PRESCRIPTION__MST_TRG" 
  before insert or update on "CON_PRESCRIPTION_MST"               
  for each row  
declare
ID_INPUT NUMBER;
begin   

if inserting then

      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

      IF :NEW.PRESCRIPTION_ID IS NULL
      THEN
     PRC_INPUT_SEQID('PRESCRIPTION_ID_SEQ',:NEW.PRESCRIPTION_ID);

      END IF;

  if :NEW.PRESCRIPTION_NO is null then 
     SELECT MAX(NVL(SUBSTR(PRESCRIPTION_NO ,8),0))+1 INTO ID_INPUT FROM CON_PRESCRIPTION_MST WHERE TO_CHAR(CREATED_ON,'YYYY')=TO_CHAR(SYSDATE,'YYYY');
     :NEW.PRESCRIPTION_NO:='P'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,5,0);
     END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;





/
ALTER TRIGGER  "CON_PRESCRIPTION__MST_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "CON_PRESCRIPTION_COUNT_TRG" 
 before insert ON CON_PRESCRIPTION_MST
 for each row
 declare
   
  v_count number;
  
 begin

 if :NEW.PRESCRIPTION_NO is not null then

 SELECT count(PRESCRIPTION_NO) into v_count FROM CON_PRESCRIPTION_MST 
 where REGISTRATION_NO=:NEW.REGISTRATION_NO
 and DOCTOR_NO =:NEW.DOCTOR_NO;

 if v_count=0 then  
 
  
  :NEW.VISIT:='1';

 
  end if;

 if v_count>0 then
   
 
  
  :NEW.VISIT:=v_count+1;

 
  end if;
   end if;
  
end;





/
ALTER TRIGGER  "CON_PRESCRIPTION_COUNT_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PO_RECEIVE_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PO_RECEIVE
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.PO_NO IS NULL
     THEN
     PRC_INPUT_SEQID('PO_NO_SEQ',ID_INPUT);

     :NEW.PO_NO:='PO-'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "WMS_PO_RECEIVE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "SH_SERVICE_TRG" 
  BEFORE INSERT OR UPDATE ON SH_SERVICE_MST
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN

      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.SH_SERVICE_NO IS NULL
     THEN
    PRC_INPUT_SEQID('SH_SERVICE_NO_SEQ',ID_INPUT);
    :NEW.SH_SERVICE_NO:='SER-'||LPAD(ID_INPUT,5,0);
    END IF;

    IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "SH_SERVICE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "GLOBAL_COMPANY_BRANCH_TRG" 
BEFORE INSERT OR UPDATE on GLOBAL_COMPANY_BRANCH
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);

BEGIN
   IF INSERTING
   THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU (:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.BRANCH_ID IS NULL
      THEN
         PRC_INPUT_SEQID ('BRANCH_ID_SEQ', :NEW.BRANCH_ID);
      END IF;

      IF :NEW.BRANCH_NO IS NULL
      THEN
     PRC_INPUT_SEQID('BRANCH_NO_SEQ',ID_INPUT);

     :NEW.BRANCH_NO:='BRANCH-'||LPAD(ID_INPUT,6,0);
      END IF;

  IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;


   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU (:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;






/
ALTER TRIGGER  "GLOBAL_COMPANY_BRANCH_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SUPPLIER_INFO_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_SUPPLIER_INFO
  FOR EACH ROW
  DECLARE
  ID_INPUT NUMBER;
BEGIN
IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.SUPPLIER_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SUPPLIER_NO_SEQ',ID_INPUT);

     :NEW.SUPPLIER_NO:='SUP-'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "WMS_SUPPLIER_INFO_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WSM_STORE_TRG" 
   BEFORE INSERT OR UPDATE OR DELETE ON WMS_STORE_MST
   FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
   IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

      IF :NEW.WSM_STORE_ID IS NULL
      THEN
     PRC_INPUT_SEQID('WSM_STORE_ID_SEQ',:NEW.WSM_STORE_ID);

      END IF;

      IF :NEW.WSM_STORE_NO IS NULL
      THEN
     PRC_INPUT_SEQID('WSM_STORE_NO_SEQ',ID_INPUT);

     :NEW.WSM_STORE_NO:='STR'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       null;
END ;






/
ALTER TRIGGER  "WSM_STORE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "GLOBAL_COMPANY_SETUP_TRG" 
BEFORE INSERT OR UPDATE on GLOBAL_COMPANY_SETUP
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);

BEGIN
   IF INSERTING
   THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU (:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.COMPANY_ID IS NULL
      THEN
         PRC_INPUT_SEQID ('COMPANY_ID_SEQ', :NEW.COMPANY_ID);
      END IF;

      IF :NEW.COMPANY_NO IS NULL
      THEN
      PRC_INPUT_SEQID('COMPANY_NO_SEQ',:NEW.COMPANY_NO);

      END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU (:NEW.UPDATED_ON, :NEW.UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;







/
ALTER TRIGGER  "GLOBAL_COMPANY_SETUP_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_REGISTRATION_TGR" 
   BEFORE INSERT OR UPDATE OR DELETE   ON BUS_REGISTRATION
   FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;



      IF :NEW.REGISTRATION_ID IS NULL
      THEN
     PRC_INPUT_SEQID('REGISTRATION_ID_SEQ',:NEW.REGISTRATION_ID);

      END IF;

     IF :NEW.REGISTRATION_NO IS NULL THEN
/*     PRC_INPUT_SEQID('REGISTRATION_NO_SEQ',ID_INPUT);

     :NEW.REGISTRATION_NO:='R'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);
*/
     SELECT MAX(NVL(SUBSTR(REGISTRATION_NO,8),0))+1 INTO ID_INPUT FROM BUS_REGISTRATION WHERE TO_CHAR(CREATED_ON,'YYYY')=TO_CHAR(SYSDATE,'YYYY');
     :NEW.REGISTRATION_NO:='R'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);
      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;






/
ALTER TRIGGER  "BUS_REGISTRATION_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "BIU_EBA_UT_CHART_PROJ" 
   before insert or update on EBA_UT_chart_projects
   for each row
begin
   if :new."ID" is null then
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual;
   end if;
   if inserting then
       :new.created := localtimestamp;
       :new.created_by := nvl(wwv_flow.g_user,user);
       :new.updated := localtimestamp;
       :new.updated_by := nvl(wwv_flow.g_user,user);
   end if;
   if inserting or updating then
       :new.updated := localtimestamp;
       :new.updated_by := nvl(wwv_flow.g_user,user);
   end if;
   if inserting then
       :new.row_version_number := 1;
   elsif updating then
       :new.row_version_number := nvl(:old.row_version_number,1) + 1;
   end if;
end;






/
ALTER TRIGGER  "BIU_EBA_UT_CHART_PROJ" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PURCHASE_ODTLS_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PURCHASE_ORDER_DTLS
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.DETAILS_NO IS NULL THEN
     PRC_INPUT_SEQID('ODETAILS_NO_SEQ',:NEW.DETAILS_NO);
      END IF;


       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION WHEN OTHERS THEN
       RAISE;
end;






/
ALTER TRIGGER  "WMS_PURCHASE_ODTLS_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_DOCTOR_MASTER_TGR" 
  BEFORE INSERT OR UPDATE ON BUS_DOCTOR_MASTER
  FOR EACH ROW
  DECLARE
  ID_INPUT NUMBER;
BEGIN
IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.DOCTOR_NO IS NULL
     THEN
     PRC_INPUT_SEQID('DOCTOR_NO_SEQ',ID_INPUT);

     :NEW.DOCTOR_NO:='DR-'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "BUS_DOCTOR_MASTER_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "GLOBAL_SESSION_GENERATE_TRG" 
BEFORE INSERT OR UPDATE on GLOBAL_SESSION_GENERATE
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
   IF INSERTING
   THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;



      IF :NEW.SESSION_NO IS NULL
      THEN
     PRC_INPUT_SEQID('SESSION_NO_SEQ',ID_INPUT);

     :NEW.SESSION_NO:='SES'||LPAD(ID_INPUT,6,0);

      END IF;



   ELSIF UPDATING
   THEN
      IF :NEW.UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.UPDATED_ON, :NEW.UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;







/
ALTER TRIGGER  "GLOBAL_SESSION_GENERATE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SH_PAYMENT_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_SH_PAYMENT   FOR EACH ROW
DECLARE
  ID_INPUT NUMBER;
  v_due NUMBER:=0;
  V_STATUS VARCHAR2(8);
  v_amount number:=0;
BEGIN

IF INSERTING THEN

if :NEW.SH_PAYMENT_PURPOSE='DUEPAID' THEN 

SELECT SUM(NVL(SH_PAYABLE_AMT,0)-NVL(SH_CASHPAID_AMT,0)) into v_due FROM WMS_SH_PAYMENT WHERE SH_INVOICE_NO=:NEW.SH_INVOICE_NO;

IF  nvl(V_due,0) < nvl(:NEW.SH_CASHPAID_AMT,0) THEN
raise_application_error(-20001, 'Payment amount grater than Invoice amount');
end if;

END IF;


      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.SH_PAYMENT_ID IS NULL
      THEN
     PRC_INPUT_SEQID('SH_PAYMENT_ID_SEQ',:NEW.SH_PAYMENT_ID);
      END IF;

 IF :NEW.SH_MR_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_MR_NO_SEQ',ID_INPUT);

     :NEW.SH_MR_NO:='PAY'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;



   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;


/
ALTER TRIGGER  "WMS_SH_PAYMENT_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "CHART_OF_ACCOUNT_TGR" 
BEFORE INSERT OR UPDATE OR DELETE   ON CHART_OF_ACCOUNT
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
    IF :NEW.CREATED_BY IS NULL
    THEN
    PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
    END IF;



      IF :NEW.ACCOUNT_ID IS NULL
      THEN
     PRC_INPUT_SEQID('ACCOUNT_ID_SEQ',:NEW.ACCOUNT_ID);

      END IF;

      IF :NEW.ACCOUNT_NO IS NULL
      THEN
     PRC_INPUT_SEQID('ACCOUNT_NO_SEQ',ID_INPUT);

     :NEW.ACCOUNT_NO:='ACC-'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
   END IF;

   END IF;

   EXCEPTION
   WHEN OTHERS THEN
   RAISE;
END ;






/
ALTER TRIGGER  "CHART_OF_ACCOUNT_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SH_INVLINE_UPDATE_TRG" 
FOR UPDATE or INSERT or DELETE ON 
WMS_SH_INVLINE 
COMPOUND TRIGGER
INV_NO VARCHAR2(200);
	V_PAID_AMT NUMBER:=0; 
	V_TOTAL_AMT NUMBER:=0; 
	V_DISCOUNT  NUMBER:=0; 
	V_BILL_AMT  NUMBER:=0; 
AFTER EACH ROW IS
  BEGIN
     INV_NO := :new.SH_INVOICE_NO;
     IF DELETING THEN
     INV_NO := :OLD.SH_INVOICE_NO;
     END IF;
END AFTER EACH ROW;

--  IF UPDATING THEN 
 AFTER STATEMENT IS
BEGIN
    SELECT SUM(NVL(SH_CASHPAID_AMT,0)), 
           SUM(NVL(SH_DISCOUNT_AMT,0)) 
    INTO   V_PAID_AMT, 
           V_DISCOUNT 
    FROM   WMS_SH_PAYMENT 
    WHERE  SH_INVOICE_NO=INV_NO;
 
 
    IF NVL(V_PAID_AMT,0)=0 THEN 

      SELECT SUM(NVL(SH_QUANTITY,0)*NVL(ITEM_RATE,0)) 
      INTO   V_TOTAL_AMT 
      FROM   WMS_SH_INVLINE 
      WHERE  SH_INVOICE_NO=INV_NO; 
     
 
      UPDATE WMS_SH_PAYMENT 
      SET    SH_BILL_AMT=V_TOTAL_AMT, 
			 SH_DISCOUNT_AMT=V_DISCOUNT, 
			 SH_PAYABLE_AMT=(NVL(V_TOTAL_AMT,0)-NVL(V_DISCOUNT,0)) 
      WHERE  SH_INVOICE_NO=INV_NO; 

    END IF; 
    
    END AFTER STATEMENT;
 
END WMS_SH_INVLINE_UPDATE_TRG;


/
ALTER TRIGGER  "WMS_SH_INVLINE_UPDATE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "IPD_ADMISSION_TRG" 
BEFORE INSERT OR UPDATE ON IPD_ADMISSION
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
   IF INSERTING
   THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

      IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
       PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;


   IF :NEW.ADMISSION_NO IS NULL
       THEN
       PRC_INPUT_SEQID('IPD_NO_SEQ',ID_INPUT);
       :NEW.ADMISSION_NO:='IPD/'||TO_CHAR(SYSDATE,'YYYY')||'/'||LPAD(ID_INPUT,6,0);
       END IF;

      IF :NEW.CABIN_NO IS NOT NULL
      THEN
  UPDATE BUS_PRICE_LIST SET BATCH_NO='BOOKED' WHERE ITEM_NO=:NEW.CABIN_NO AND COMPANY_NO=FNC_COMPANY_sESSION(V('APP_SESSION'));
      END IF;

   ELSIF UPDATING
   THEN
       IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;


  if NVL(:NEW.DISCHARGE_FLAG,'N') = 'Y' AND NVL(:OLD.DISCHARGE_FLAG,'N') = 'N' then
        PRC_INPUT_DU(:NEW.DISCHARGE_DATE, :NEW.DISCHARGE_BY);
UPDATE BUS_PRICE_LIST SET BATCH_NO=NULL WHERE ITEM_NO=:NEW.CABIN_NO AND COMPANY_NO=FNC_COMPANY_sESSION(V('APP_SESSION'));
      END IF;

    if NVL(:NEW.DISCHARGE_REQUEST_FLAG,'N') = 'Y' AND NVL(:OLD.DISCHARGE_REQUEST_FLAG,'N') = 'N' then
        PRC_INPUT_DU(:NEW.DISCHARGE_REQUEST_ON, :NEW.DISCHARGE_REQUEST_BY);
      END IF;


         END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END;





/
ALTER TRIGGER  "IPD_ADMISSION_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PURCHASE_DTLS_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PURCHASE_REQUISITION_DTLS
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.DETAILS_NO IS NULL THEN
     PRC_INPUT_SEQID('DETAILS_NO_SEQ',:NEW.DETAILS_NO);
      END IF;


       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION WHEN OTHERS THEN
       RAISE;
end;






/
ALTER TRIGGER  "WMS_PURCHASE_DTLS_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SH_INVLINE_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_SH_INVLINE   FOR EACH ROW
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.SH_INVLINE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_INVLINE_NO_SEQ',ID_INPUT);

     :NEW.SH_INVLINE_NO:='ILN'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;



end;






/
ALTER TRIGGER  "WMS_SH_INVLINE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "SUP_BILL_dtls_TGR" 
  before insert on "SUP_BILL_DTLS"               
  for each row  
begin   
  if :NEW."ID" is null then 
    select "SUP_BILL_DTLS_SEQ".nextval into :NEW."ID" from dual; 
  end if; 
end;



/
ALTER TRIGGER  "SUP_BILL_dtls_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "EXPENDITURE_DR_TGR" 
BEFORE INSERT OR UPDATE OR DELETE   ON EXPENDITURE_DR
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
    IF :NEW.CREATED_BY IS NULL
    THEN
    PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
    END IF;

      IF :NEW.EXPENDITURE_ID IS NULL
      THEN
     PRC_INPUT_SEQID('EXPENDITURE_ID_SEQ',:NEW.EXPENDITURE_ID);

      END IF;

      IF :NEW.EXPENDITURE_NO IS NULL
      THEN
     PRC_INPUT_SEQID('EXPENDITURE_NO_SEQ',ID_INPUT);

     :NEW.EXPENDITURE_NO:='EXP-'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
   END IF;

   END IF;

   IF NVL(:OLD.SUBMITTED_FLAG, 'N') = 'N' AND NVL(:NEW.SUBMITTED_FLAG, 'N') = 'Y' THEN
    PRC_INPUT_DU(:NEW.SUBMITTED_ON, :NEW.SUBMITTED_BY);
    END IF;

  IF NVL(:OLD.APPROVED_FLAG, 'N') = 'N' AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
    PRC_INPUT_DU(:NEW.APPROVED_ON, :NEW.APPROVED_BY);

IF :OLD.PAYMENT_TYPE='Cash'  and :OLD.ACCOUNT_NO IS NOT NULL  AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
INSERT INTO GL_STATEMENT (VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,DEBIT,CREDIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,'CASH ACCOUNT',:NEW.EXPENSE_HEAD,'Cash Paid>'||:NEW.PAID_TO||'>'||:NEW.DETAILS,0,:NEW.AMOUNT,NULL,SYSDATE,'Y');
INSERT INTO GL_STATEMENT (VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,DEBIT,CREDIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:NEW.EXPENSE_HEAD,'CASH ACCOUNT','Cash Paid>'||:NEW.PAID_TO||'>'||:NEW.DETAILS,:NEW.AMOUNT,0,NULL,sysdate,'Y');

ELSIF :old.PAYMENT_TYPE='Bank' and :OLD.ACCOUNT_NO is not null AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
INSERT INTO GL_STATEMENT(VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,CREDIT,DEBIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:OLD.ACCOUNT_NO ,:NEW.EXPENSE_HEAD,'Chq Paid>'||:NEW.CHEQUE_NO||'>'||:NEW.DETAILS,0,:NEW.AMOUNT,NULL,SYSDATE,'Y');

INSERT INTO GL_STATEMENT(VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,CREDIT,DEBIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:NEW.EXPENSE_HEAD,:OLD.ACCOUNT_NO ,'Chq Paid>'||:NEW.CHEQUE_NO||'>'||:NEW.DETAILS,:NEW.AMOUNT,0,NULL,SYSDATE,'Y');

END IF;
end if;
   EXCEPTION
   WHEN OTHERS THEN
   RAISE;
END ;






/
ALTER TRIGGER  "EXPENDITURE_DR_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_PRICE_MST_TRG" 
  BEFORE INSERT OR UPDATE ON BUS_PRICE_MST
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.PRICE_LIST IS NULL THEN
     PRC_INPUT_SEQID('PRICE_LIST_SEQ',:NEW.PRICE_LIST);
      END IF;


       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION WHEN OTHERS THEN
       RAISE;
end;





/
ALTER TRIGGER  "BUS_PRICE_MST_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "BIU_EBA_UT_CHART_TASKS" 
   before insert or update on EBA_UT_chart_tasks
   for each row
begin
   if :new."ID" is null then
     select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into :new.id from dual;
   end if;
   if inserting then
       :new.created := localtimestamp;
       :new.created_by := nvl(wwv_flow.g_user,user);
       :new.updated := localtimestamp;
       :new.updated_by := nvl(wwv_flow.g_user,user);
   end if;
   if inserting or updating then
       :new.updated := localtimestamp;
       :new.updated_by := nvl(wwv_flow.g_user,user);
   end if;
   if inserting then
       :new.row_version_number := 1;
   elsif updating then
       :new.row_version_number := nvl(:old.row_version_number,1) + 1;
   end if;
end;






/
ALTER TRIGGER  "BIU_EBA_UT_CHART_TASKS" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SH_INVHEADER_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_SH_INVHEADER
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.SH_INVOICE_ID IS NULL
      THEN
     PRC_INPUT_SEQID('SH_INVOICE_ID_SEQ',:NEW.SH_INVOICE_ID);
      END IF;

 IF :NEW.SH_INVOICE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_INVOICE_NO_SEQ',ID_INPUT);

     :NEW.SH_INVOICE_NO:='INV'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "WMS_SH_INVHEADER_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_PRICE_LIST_TRG" 
  BEFORE INSERT OR UPDATE ON BUS_PRICE_LIST
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.PRICE_LINE_NO IS NULL THEN
     PRC_INPUT_SEQID('PRICE_LINE_NO_SEQ',:NEW.PRICE_LINE_NO);
      END IF;


       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION WHEN OTHERS THEN
       RAISE;
end;






/
ALTER TRIGGER  "BUS_PRICE_LIST_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "SH_PAYMENT_TRG" 
  BEFORE INSERT OR UPDATE ON SH_PAYMENT   FOR EACH ROW
DECLARE
  ID_INPUT NUMBER;
BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.SH_PAYMENT_ID IS NULL
      THEN
     PRC_INPUT_SEQID('SH_PAYMENT_ID_SEQ',:NEW.SH_PAYMENT_ID);
      END IF;

 IF :NEW.SH_MR_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_MR_NO_SEQ',ID_INPUT);

     :NEW.SH_MR_NO:='MR'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "SH_PAYMENT_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "RECEIVED_CR_TGR" 
BEFORE INSERT OR UPDATE OR DELETE   ON RECEIVED_CR
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
    IF :NEW.CREATED_BY IS NULL
    THEN
    PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
    END IF;

      IF :NEW.RECEIVED_ID IS NULL
      THEN
     PRC_INPUT_SEQID('RECEIVED_ID_SEQ',:NEW.RECEIVED_ID);

      END IF;

      IF :NEW.RECEIVED_NO IS NULL
      THEN
     PRC_INPUT_SEQID('RECEIVED_NO_SEQ',ID_INPUT);

     :NEW.RECEIVED_NO:='REC-'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
   END IF;

   END IF;

   IF NVL(:OLD.SUBMITTED_FLAG, 'N') = 'N' AND NVL(:NEW.SUBMITTED_FLAG, 'N') = 'Y' THEN
    PRC_INPUT_DU(:NEW.SUBMITTED_ON, :NEW.SUBMITTED_BY);
    END IF;

   IF NVL(:OLD.APPROVED_FLAG, 'N') = 'N' AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
    PRC_INPUT_DU(:NEW.APPROVED_ON, :NEW.APPROVED_BY);

IF :OLD.PAYMENT_TYPE='Cash'  and :OLD.ACCOUNT_NO IS NOT NULL  AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
INSERT INTO GL_STATEMENT (VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,DEBIT,CREDIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,'CASH ACCOUNT',:NEW.INCOME_HEAD,'Cash Received>'||:NEW.PAID_TO||'>'||:NEW.DETAILS,:NEW.AMOUNT,0,NULL,SYSDATE,'Y');
INSERT INTO GL_STATEMENT (VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,DEBIT,CREDIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:NEW.INCOME_HEAD,'CASH ACCOUNT','Cash Received>'||:NEW.PAID_TO||'>'||:NEW.DETAILS,0,:NEW.AMOUNT,NULL,sysdate,'Y');

ELSIF :old.PAYMENT_TYPE='Bank' and :OLD.ACCOUNT_NO is not null AND NVL(:NEW.APPROVED_FLAG, 'N') = 'Y' THEN
INSERT INTO GL_STATEMENT(VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,CREDIT,DEBIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:OLD.ACCOUNT_NO ,:NEW.INCOME_HEAD,'Chq Deposit>'||:NEW.CHEQUE_NO||'>'||:NEW.DETAILS,0,:NEW.AMOUNT,NULL,SYSDATE,'Y');

INSERT INTO GL_STATEMENT(VOUCHER_ID,ACCOUNT_NO,HEAD,PARTICULAR,CREDIT,DEBIT,BALANCE,GL_DATE,ACTIVE_STATUS) VALUES
(:NEW.VOUCHER_NO,:NEW.INCOME_HEAD,:OLD.ACCOUNT_NO ,'Chq Deposit>'||:NEW.CHEQUE_NO||'>'||:NEW.DETAILS,:NEW.AMOUNT,0,NULL,SYSDATE,'Y');

END IF;
    END IF;
   EXCEPTION
   WHEN OTHERS THEN
   RAISE;
END ;







/
ALTER TRIGGER  "RECEIVED_CR_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "APP_ID_TGR" 
              before insert on ERP_MAIN_APPLICATION
              for each row
              begin
                  if :new.ID is null then
                      select APP_ID_SEQ.nextval into :new.ID from sys.dual;
                 end if;
              end;





/
ALTER TRIGGER  "APP_ID_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "SH_INVHEADER_TRG" 
  BEFORE INSERT OR UPDATE ON SH_INVHEADER
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.SH_INVOICE_ID IS NULL
      THEN
     PRC_INPUT_SEQID('SH_INVOICE_ID_SEQ',:NEW.SH_INVOICE_ID);
      END IF;

 IF :NEW.SH_INVOICE_NO IS NULL
     THEN
    -- PRC_INPUT_SEQID('SH_INVOICE_NO_SEQ',ID_INPUT);
    
     SELECT NVL(MAX(SUBSTR(SH_INVOICE_NO ,8))+1,1) INTO ID_INPUT FROM SH_INVHEADER WHERE TO_CHAR(SH_INVOICE_DATE,'MON-YY')=TO_CHAR(SYSDATE,'MON-YY');


     :NEW.SH_INVOICE_NO:='I'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "SH_INVHEADER_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "GL_STATEMENT_TGR" 
BEFORE INSERT OR UPDATE OR DELETE   ON GL_STATEMENT
FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
    IF :NEW.CREATED_BY IS NULL
    THEN
    PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
    END IF;

      IF :NEW.GL_ID IS NULL
      THEN
     PRC_INPUT_SEQID('GL_ID_SEQ',:NEW.GL_ID);

      END IF;

    --   IF :NEW.COMPANY_NO IS NULL AND BRANCH_NO IS NOT NULL THEN

    --  PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.CB.BRANCH_NO);

--   END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
   END IF;

   END IF;

   EXCEPTION
   WHEN OTHERS THEN
   RAISE;
END ;






/
ALTER TRIGGER  "GL_STATEMENT_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "SH_INVLINE_TRG" 
  BEFORE INSERT OR UPDATE ON SH_INVLINE   FOR EACH ROW
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.SH_INVLINE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_INVLINE_NO_SEQ',ID_INPUT);

     :NEW.SH_INVLINE_NO:='ILN'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;



end;






/
ALTER TRIGGER  "SH_INVLINE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PURCHASE_REQUISITION_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PURCHASE_REQUISITION
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.REQUISITION_ID IS NULL
      THEN
     PRC_INPUT_SEQID('REQUISITION_ID_SEQ',:NEW.REQUISITION_ID);
      END IF;

 IF :NEW.REQUISITION_NO IS NULL
     THEN
     PRC_INPUT_SEQID('REQUISITION_NO_SEQ',ID_INPUT);

     :NEW.REQUISITION_NO:='REQ'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "WMS_PURCHASE_REQUISITION_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "USER_ACCESS_TGR" 
  BEFORE INSERT OR UPDATE ON USER_ACCESS
  FOR EACH ROW

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL 
       THEN 
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO); 
       END IF; 

 IF :NEW.ACCESS_ID IS NULL
     THEN
     SELECT NVL(MAX(ACCESS_ID)+1,1) INTO :NEW.ACCESS_ID FROM USER_ACCESS;
      END IF;

   ELSIF UPDATING
   THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
end;




/
ALTER TRIGGER  "USER_ACCESS_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_ITEM_MASTER_TGR" 
   BEFORE INSERT OR UPDATE OR DELETE   ON BUS_ITEM_MASTER
   FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;



      IF :NEW.ITEM_ID IS NULL
      THEN
     PRC_INPUT_SEQID('ITEM_ID_SEQ',:NEW.ITEM_ID);

      END IF;

      IF :NEW.ITEM_NO IS NULL
      THEN
     PRC_INPUT_SEQID('ITEM_NO_SEQ',ID_INPUT);

     :NEW.ITEM_NO:='I'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;







/
ALTER TRIGGER  "BUS_ITEM_MASTER_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "SUP_BILL_TGR" 
  before insert on SUP_BILL_MST              
  for each row  
begin   
  if :NEW."ID" is null then 
    select "SUB_BILL_ID_SEQ".nextval into :NEW."ID" from dual; 
  end if; 
end;



/
ALTER TRIGGER  "SUP_BILL_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "SH_SERLINE_TRG" 
  BEFORE INSERT OR UPDATE ON SH_SERLINE   FOR EACH ROW
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.SH_SERLINE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('SH_SERVICE_NO_SEQ',ID_INPUT);

     :NEW.SH_SERLINE_NO:='SLN'||LPAD(ID_INPUT,5,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
end;






/
ALTER TRIGGER  "SH_SERLINE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PO_RECEIVE_DTLS_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PO_RECEIVE_DTLS
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.DETAILS_NO IS NULL THEN
     PRC_INPUT_SEQID('PODETAILS_NO_SEQ',:NEW.DETAILS_NO);
      END IF;


       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION WHEN OTHERS THEN
       RAISE;
end;






/
ALTER TRIGGER  "WMS_PO_RECEIVE_DTLS_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_EMPLOYEE_PROFILE_TRG" 
  before insert OR UPDATE on HRM_EMPLOYEE_PROFILE
  for each row
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.EMPLOYEE_ID IS NULL
      THEN
     PRC_INPUT_SEQID('EMPLOYEE_ID_SEQ',:NEW.EMPLOYEE_ID);
      END IF;

 IF :NEW.EMPLOYEE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('EMPLOYEE_NO_SEQ',ID_INPUT);

     :NEW.EMPLOYEE_NO:='EMP'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL
       THEN
      :NEW.COMPANY_NO := FNC_COMPANY_SESSION (V ('APP_SESSION'));
       END IF;

       IF :NEW.BRANCH_NO IS NULL
       THEN
      :NEW.BRANCH_NO := FNC_BRANCH_SESSION (V ('APP_SESSION'));
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;






/
ALTER TRIGGER  "HRM_EMPLOYEE_PROFILE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "BUS_UNIT_SETUP_TGR" 
   BEFORE INSERT OR UPDATE OR DELETE   ON BUS_UNIT_SETUP
   FOR EACH ROW
DECLARE
ID_INPUT VARCHAR2(16);
BEGIN
  IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

      IF :NEW.UNIT_NO IS NULL
      THEN
SELECT 'UOM'||LPAD(COUNT(UNIT_NO)+1,5,0) INTO :NEW.UNIT_NO FROM BUS_UNIT_SETUP;
      END IF;

IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;


   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;
END ;







/
ALTER TRIGGER  "BUS_UNIT_SETUP_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_PURCHASE_ORDER_TRG" 
  BEFORE INSERT OR UPDATE ON WMS_PURCHASE_ORDER
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;


      IF :NEW.ORDER_ID IS NULL
      THEN
     PRC_INPUT_SEQID('ORDER_ID_SEQ',:NEW.ORDER_ID);
      END IF;

 IF :NEW.ORDER_NO IS NULL
     THEN
     PRC_INPUT_SEQID('ORDER_NO_SEQ',ID_INPUT);

     :NEW.ORDER_NO:='OD'||TO_CHAR(SYSDATE,'DDMMRR')||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;


end;






/
ALTER TRIGGER  "WMS_PURCHASE_ORDER_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_ATTENDANCE_TRG" 
  before insert OR UPDATE on HRM_ATTENDANCE
  for each row
DECLARE

  ID_INPUT NUMBER;

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.ATTENDANCE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('HRM_ATTENDANCE_NO_SEQ',ID_INPUT);
     :NEW.ATTENDANCE_NO:='AT'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HRM_ATTENDANCE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_DEPT_TRG" 
  before insert OR UPDATE on HRM_DEPT
  for each row
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.DEPT_NO IS NULL
     THEN
     PRC_INPUT_SEQID('DEPT_NO_SEQ',ID_INPUT);

     :NEW.DEPT_NO:='ILN'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;



end;

/
ALTER TRIGGER  "HRM_DEPT_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_DESIGNATION_TRG" 
  before insert OR UPDATE on HRM_DESIGNATION
  for each row
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.DESIGNATION_NO IS NULL
     THEN
     PRC_INPUT_SEQID('DESIGNATION_NO_SEQ',ID_INPUT);
     :NEW.DESIGNATION_NO:='DG'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HRM_DESIGNATION_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_SALARY_CAL_TRG" 
  before insert OR UPDATE on HRM_SALARY_CAL_MST
  for each row
begin

if inserting then
:new.CREATED_ON:=sysdate;
:new.CREATED_BY:=UPPER(v('APP_USER'));
:new.COMPANY_NO:= FNC_COMPANY_SESSION(V('APP_SESSION'));
  if :NEW.SALARY_CALMST_NO is null then
SELECT NVL(MAX(SALARY_CALMST_NO)+1,1) INTO :NEW.SALARY_CALMST_NO FROM HRM_SALARY_CAL_MST;

  end if;
	  IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
      END IF;
	  
	  
elsif updating then

:new.LAST_UPDATED_ON:=sysdate;
:new.LAST_UPDATED_BY:=UPPER(v('APP_USER'));

end if;

end;

/
ALTER TRIGGER  "HRM_SALARY_CAL_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_ADVANCE_TGR" 
  BEFORE INSERT OR UPDATE ON HRM_ADVANCE
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;
      
 IF :NEW.ADVANCE_NO IS NULL
     THEN

     SELECT NVL(MAX(TO_NUMBER(ADVANCE_NO))+1,1) INTO :NEW.ADVANCE_NO FROM HRM_ADVANCE;

      END IF;
      
	  IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
      END IF;

ELSIF UPDATING
   THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HRM_ADVANCE_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_HED_DEGREE_TRG" 
  before insert OR UPDATE on HRM_EDUCATION_DEGREE
  for each row
DECLARE

  ID_INPUT NUMBER;

BEGIN


IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;

 IF :NEW.HED_DEGREE_NO IS NULL
     THEN
     PRC_INPUT_SEQID('HED_DEGREE_NO_SEQ',ID_INPUT);

     :NEW.HED_DEGREE_NO:='ILN'||LPAD(ID_INPUT,6,0);

      END IF;

       IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL
       THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
       END IF;

   ELSIF UPDATING
   THEN
      IF :NEW.LAST_UPDATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);
      END IF;

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HRM_HED_DEGREE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_EMP_WORKING_DAYS_TRG" 
  before insert OR UPDATE on HRM_EMP_WORKING_DAYS
  for each row
begin

if inserting then
:new.CREATED_ON:=sysdate;
:new.CREATED_BY:=UPPER(v('APP_USER'));
  if :NEW.COMPANY_NO is null then
:new.COMPANY_NO:= FNC_COMPANY_SESSION(V('APP_SESSION'));
  end if;
  if :NEW.WORKING_DAY_ID is null then
    select HRM_EMP_WORKING_DAY_ID_SEQ.nextval into :NEW.WORKING_DAY_ID from dual;
  end if;


elsif updating then

:new.LAST_UPDATED_ON:=sysdate;
:new.LAST_UPDATED_BY:=UPPER(v('APP_USER'));

end if;

end;

/
ALTER TRIGGER  "HRM_EMP_WORKING_DAYS_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "WMS_SALARY_APPROVE_TRG" 
  before UPDATE OF APPROVE_FLAG on  HRM_SALARY_CAL_MST
  for each row
declare
  v_amount number:=0;
begin
if nvl(:NEW.APPROVE_FLAG,'N')<>nvl(:OLD.APPROVE_FLAG,'N') then
   :new.APPROVE_ON:=sysdate;
   :new.APPROVE_BY:=UPPER(v('APP_USER'));
 
 select 
sum((NVL(PAY_SALARY,0)+NVL(MEDICAL_ALLOW,0)+NVL(BONUS,0)-NVL(ADVANCE_AMT,0))) INTO v_amount
  from HRM_SALARY_CAL_DTL
  where SALARY_CALMST_NO=:NEW.SALARY_CALMST_NO;
  
  :NEW.TOTAL_AMOUNT:=v_amount;
  
  FOR A IN ( SELECT ADVANCE_NO, ADVANCE_AMT ,EMPLOYEE_NO FROM HRM_SALARY_CAL_DTL D WHERE D.SALARY_CALMST_NO=:NEW.SALARY_CALMST_NO AND D.ADVANCE_AMT>0)
  LOOP
  	UPDATE HRM_ADVANCE 
		SET ADVANCE_BALANCE=ADVANCE_BALANCE-A.ADVANCE_AMT 
		WHERE EMPLOYEE_NO=A.EMPLOYEE_NO 
		AND ADVANCE_NO=A.ADVANCE_NO 
		AND ADVANCE_BALANCE>0;
	--	COMMIT;
		
	UPDATE 	HRM_ADVANCE SET ACTIVE_STATUS='N'
	WHERE NVL(ACTIVE_STATUS,'N')='Y' 
	AND ADVANCE_BALANCE=0
	AND EMPLOYEE_NO=A.EMPLOYEE_NO 
	AND ADVANCE_NO=A.ADVANCE_NO ;
	--COMMIT;
	
  END LOOP;
   
end if;
end;

/
ALTER TRIGGER  "WMS_SALARY_APPROVE_TRG" ENABLE
/
CREATE OR REPLACE TRIGGER  "HRM_SALARY_CALDTL_TGR" 
  BEFORE INSERT OR UPDATE ON HRM_SALARY_CAL_DTL
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;
      
 IF :NEW.SALARY_CALDTL_NO IS NULL
     THEN

     SELECT NVL(MAX(SALARY_CALDTL_NO)+1,1) INTO :NEW.SALARY_CALDTL_NO FROM HRM_SALARY_CAL_DTL;

      END IF;
      
	  IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
      END IF;

ELSIF UPDATING
   THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HRM_SALARY_CALDTL_TGR" ENABLE
/
CREATE OR REPLACE TRIGGER  "HOLI_DAY_TRG" 
  BEFORE INSERT OR UPDATE ON HOLIDAY_SETUP
  FOR EACH ROW
  DECLARE

  ID_INPUT NUMBER;

BEGIN

IF INSERTING THEN
      IF :NEW.CREATED_BY IS NULL
      THEN
         PRC_INPUT_DU(:NEW.CREATED_ON, :NEW.CREATED_BY);
      END IF;
      
 IF :NEW.HOLI_ID IS NULL
     THEN

     SELECT NVL(MAX(HOLI_ID)+1,1) INTO :NEW.HOLI_ID FROM HOLIDAY_SETUP;

      END IF;
      
	  IF :NEW.COMPANY_NO IS NULL AND :NEW.BRANCH_NO IS NULL THEN
      PRC_CB_SESSION (V ('APP_SESSION'),:NEW.COMPANY_NO,:NEW.BRANCH_NO);
      END IF;

ELSIF UPDATING
   THEN
         PRC_INPUT_DU(:NEW.LAST_UPDATED_ON, :NEW.LAST_UPDATED_BY);

   END IF;

   EXCEPTION
     WHEN OTHERS THEN
       RAISE;

end;

/
ALTER TRIGGER  "HOLI_DAY_TRG" ENABLE
/
CREATE OR REPLACE FORCE VIEW  "IPD_PATIENT_BILL" ("ADMISSION_NO", "REGISTRATION_NO", "REG_CHARGE", "CABIN_CHARGE", "CON_VISIT", "INV_CHARGE_PTL", "INV_CHARGE_NON_PTL", "OT", "MEDICINES", "CONSUMABLES", "WORD_ICU_SERVICES", "GENERAL_PROCEDURE", "TOTAL_AMOUNT", "VAT_AMOUNT", "DISCOUNT_AMOUNT", "NET_TOTAL", "ADVANCED_AMOUNT", "DUE_AMOUNT", "RECEIVED_AMOUNT", "REFUND_AMOUNT") AS 
  SELECT ADMISSION_NO,REGISTRATION_NO,
FNC_ITEM_NAME(ADMISSION_CHARGE,'RATE') REG_CHARGE,
FNC_ITEM_NAME(CABIN_NO,'RATE')*DAYDIFF(DISCHARGE_DATE,ADMISSION_DATE) CABIN_CHARGE,

NVL((SELECT RATE FROM BUS_PRICE_LIST L, BUS_ITEM_MASTER M 
WHERE M.ITEM_NO=L.ITEM_NO 
AND NVL(L.ACTIVE_sTATUS,'N')='Y' AND NVL(M.ACTIVE_sTATUS,'N')='Y' 
AND M.ITEM_NAME='Consultant Fee' AND ROWNUM=1),0)*DAYDIFF(DISCHARGE_DATE,ADMISSION_DATE) CON_VISIT,

NVL((
SELECT SUM(SH_QUANTITY*ITEM_RATE) FROM SH_INVLINE L, SH_INVHEADER H, BUS_ITEM_MASTER M 
WHERE M.ITEM_NO=L.ITEM_NO
AND M.ITEM_CATEGORY='Pathology' 
AND H.SH_INVOICE_NO=L.SH_INVOICE_NO
AND h.SH_CUSTOMER_ID=AD.ADMISSION_NO
AND H.CUSTOMER_TYPE='Int'),0) INV_CHARGE_PTL,

NVL((SELECT SUM(SH_QUANTITY*ITEM_RATE) FROM SH_INVLINE L, SH_INVHEADER H, BUS_ITEM_MASTER M 
WHERE M.ITEM_NO=L.ITEM_NO
AND M.ITEM_CATEGORY='Radiology' 
AND H.SH_INVOICE_NO=L.SH_INVOICE_NO
AND h.SH_CUSTOMER_ID=AD.ADMISSION_NO
AND H.CUSTOMER_TYPE='Int'),0) INV_CHARGE_NON_PTL,

NVL((
SELECT SUM (NVL(l.item_rate,0)*NVL(l.SH_quantity,0)) FROM SH_serline L, BUS_ITEM_MASTER M , SH_service_mst S
WHERE M.ITEM_NO=L.ITEM_NO 
AND l.SH_service_no= s.SH_service_no
AND s.customer_type='Int'
and s.SH_customer_id=AD.ADMISSION_NO
AND NVL(M.ACTIVE_sTATUS,'N')='Y' 
AND m.item_type='IPD Service'
AND M.sub_category='OT'
),0) OT,

nvl((SELECT SUM(SH_PAYABLE_AMT) FROM WMS_SH_INVHEADER H, WMS_SH_PAYMENT P
WHERE H.SH_INVOICE_NO=P.SH_INVOICE_NO
AND h.SH_CUSTOMER_ID=AD.ADMISSION_NO
AND H.CUSTOMER_TYPE='Int'),0) Medicines,

NVL((
SELECT SUM (NVL(l.item_rate,0)*NVL(l.SH_quantity,0)) FROM SH_serline L, BUS_ITEM_MASTER M , SH_service_mst S
WHERE M.ITEM_NO=L.ITEM_NO 
AND l.SH_service_no= s.SH_service_no
AND s.customer_type='Int'
and s.SH_customer_id=AD.ADMISSION_NO
AND NVL(M.ACTIVE_sTATUS,'N')='Y' 
AND m.item_type='IPD Service'
AND M.sub_category='CONSUMABLES'
),0) Consumables,

NVL((
SELECT SUM (NVL(l.item_rate,0)*NVL(l.SH_quantity,0)) FROM SH_serline L, BUS_ITEM_MASTER M , SH_service_mst S
WHERE M.ITEM_NO=L.ITEM_NO 
AND l.SH_service_no= s.SH_service_no
AND s.customer_type='Int'
and s.SH_customer_id=AD.ADMISSION_NO
AND NVL(M.ACTIVE_sTATUS,'N')='Y' 
AND m.item_type='IPD Service'
AND M.sub_category='WORD-ICU SERVICE'
),0) Word_ICU_Services,

NVL((
SELECT SUM (NVL(l.item_rate,0)*NVL(l.SH_quantity,0)) FROM SH_serline L, BUS_ITEM_MASTER M , SH_service_mst S
WHERE M.ITEM_NO=L.ITEM_NO 
AND l.SH_service_no= s.SH_service_no
AND s.customer_type='Int'
and s.SH_customer_id=AD.ADMISSION_NO
AND NVL(M.ACTIVE_sTATUS,'N')='Y' 
AND m.item_type='IPD Service'
AND M.sub_category='OTHERS'
),0) General_Procedure,

NVL((SELECT SUM(SH_bill_amt) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='IPD_PAID'),0) Total_Amount,

NVL((SELECT SUM(SH_vat_amt) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='IPD_PAID'),0) VAT_Amount,

NVL((SELECT SUM(SH_discount_amt) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='IPD_PAID'),0) Discount_Amount,

NVL((SELECT SUM(SH_PAYABLE_amt) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='IPD_PAID'),0) Net_Total,

NVL((SELECT SUM(nvl(card_amt,0)+nvl(SH_cashpaid_amt,0)) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='ADVANCE'),0) Advanced_Amount,

NVL(NVL((SELECT SUM(SH_payable_amt)-SUM(nvl(card_amt,0)+nvl(SH_cashpaid_amt,0)) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose in ('IPD_PAID','DUEPAID')),0)
-
NVL((SELECT SUM(SH_bill_amt) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='ADVANCE'),0),0) Due_Amount,

NVL((SELECT SUM(nvl(card_amt,0)+nvl(SH_cashpaid_amt,0)) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose IN ('IPD_PAID','DUEPAID')),0) Received_Amount,

NVL((SELECT SUM(SH_refund_amount) 
FROM SH_PAYMENT P 
WHERE P.ipd_admission_no=AD.ADMISSION_NO 
AND P.SH_payment_purpose='REFUND'),0) Refund_Amount
FROM IPD_ADMISSION AD
/
