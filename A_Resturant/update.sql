    
 IF EXISTS(SELECT Name FROM SYS.Objects WHERE Object_ID = OBJECT_ID(N'iteme_profit') AND TYPE IN(N'P', N'PC'))
	DROP PROCEDURE [iteme_profit]
GO
 
 create proc  [dbo].[iteme_profit]
  @dat1 datetime='2017-10-07', ---='2017-10-07',
  @dat2 datetime='2022-10-07', ---='2019-10-07',
  @guid_st uniqueidentifier='00000000-0000-0000-0000-000000000000' ,
  @guid_mt uniqueidentifier='00000000-0000-0000-0000-000000000000' ,
  @guid_bransh uniqueidentifier='00000000-0000-0000-0000-000000000000',
@guid_costcenter uniqueidentifier ='00000000-0000-0000-0000-000000000000',
@guid_salesman uniqueidentifier ='00000000-0000-0000-0000-000000000000',
 @guid_Categorye uniqueidentifier  ='00000000-0000-0000-0000-000000000000',
 @idcurrncye uniqueidentifier='a36964c4-9e7e-45bb-8ae8-af4f5470f2a5',
 @CurRate float=1 
 as
 begin

 
 
 
 

 



   declare @tb_mt table(guid uniqueidentifier)
 if(@guid_mt  ='00000000-0000-0000-0000-000000000000')
 begin
 insert into @tb_mt select guid from TB_ITM
 end
  if(@guid_mt  !='00000000-0000-0000-0000-000000000000')
 begin
  INSERT  INTO @tb_mt  (guid)values(@guid_mt)
 
 end






 --drop table #temp

    declare @Log_company nvarchar(max)
,@NAMEcompany nvarchar(max)
,@PHONEcompany nvarchar(max)
,@MOBILEcompany nvarchar(max)
,@EMAILcompany nvarchar(max)
,@TaxNumbecompanyr nvarchar(max)
,@Notecompany nvarchar(max)
 ,@WEBcompany nvarchar(max)

SELECT top 1  @Log_company=[Log_company]
      ,@NAMEcompany=[NAME]
      ,@PHONEcompany=[PHONE]
      ,@MOBILEcompany=[MOBILE]
      ,@EMAILcompany=[EMAIL]
      ,@WEBcompany=[WEB]
      ,@TaxNumbecompanyr=[TaxNumber]
      ,@Notecompany=[Note]
      
  FROM [dbo].[Company]
 


 select type_bill_number,NAME_BILL1,NUMBER_BILL_1,DATE_BILL_1,NameA_CUSTOMER,BARCODE_bill_2,GUID_ITEME_bill_2,name_iteme,
 qty,Ratio_unit,price,disc_bill_2,extra_bill_2,VAT_bill_2,VAT_R_bill_2,nameA_unit_bill_2,NOTE_bill_2,
 ((qty*price)+extra_bill_2-disc_bill_2)totalbill2,
PARENT_GUID_BILL_1,nameA_store_bill_2,guid_store_bill_2,TB_CategoryCode,TB_CategorynameA,
Average,
((cASE WHEN  type_bill_number = 3   THEN -(qty*(price/Ratio_unit))-(qty*Average)   ELSE (qty*(price/Ratio_unit))-(qty*Average) END) -disc_bill_2+extra_bill_2 )profit,
 @Log_company  Log_company,
@NAMEcompany NAMEcompany,
@MOBILEcompany MOBILEcompany ,
@EMAILcompany EMAILcompany,
@TaxNumbecompanyr TaxNumbecompanyr,
@Notecompany Notecompany,
 @WEBcompany WEBcompany,
  @dat1 fromdate,
@dat2 todate
 from(

				SELECT     V_bill_1.type_bill_number  ,   dbo.V_bill_1.NAME_BILL1,
				 dbo.V_bill_1.NUMBER_BILL_1, 
				 dbo.V_bill_1.DATE_BILL_1, 
				 dbo.V_bill_1.NameA_CUSTOMER,
				  dbo.V_bill_2.BARCODE_bill_2, 
									V_bill_2.GUID_ITEME_bill_2, 
					   dbo.V_bill_2.code_iteme_bill_2 +'   '+ dbo.V_bill_2.nameA_iteme_bill_2 AS name_iteme,
						(V_bill_2.QTY_bill_2* V_bill_2.V_bill_2RatioUnit ) qty,
						 
						    (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then   (  dbo.FunINFIRST (GUID_ITEME_bill_2 , V_bill_1.DATE_BILL_1 )) when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then ( ( dbo.FunINFIRST (GUID_ITEME_bill_2 , V_bill_1.DATE_BILL_1 ))* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)Average,
						V_bill_2RatioUnit  Ratio_unit,
						 
						   (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.PRICE_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.PRICE_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)price,						 
						    (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.disc_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.disc_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)disc_bill_2,
						 (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.extra_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.extra_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)extra_bill_2,
						(case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.VAT_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.VAT_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)VAT_bill_2,
						   dbo.V_bill_2.VAT_R_bill_2,
						    V_bill_2.V_bill_2name_unit  nameA_unit_bill_2,
							 
							 dbo.V_bill_2.NOTE_bill_2,
							  dbo.V_bill_1.PARENT_GUID_BILL_1,
							   dbo.V_bill_2.nameA_store_bill_2, 
							    dbo.V_bill_2.guid_store_bill_2, 
                             
						 TB_Category.code TB_CategoryCode,
						 TB_Category.nameA TB_CategorynameA
						
 
 
FROM            dbo.V_bill_1 INNER JOIN
                         dbo.V_bill_2 ON dbo.V_bill_1.GUID_BILL_1 = dbo.V_bill_2.PARENT_GUID_bill_2
						 inner join TB_Category on TB_Category.Guid=V_bill_2.iteme_parentguid
 						   
						  WHERE  (V_bill_1.ispost_bill_1=1)  
						  and  V_bill_1.type_bill_number in ( 2,3)
						  and (V_bill_1.isdelete_bill_1=0)
						     and
						  ( TB_Category.guid in   (select guid from  dbo.fun_category_Filter( @guid_Categorye )   ) )
						  and  (V_bill_1.ispost_bill_1=1)  and (V_bill_1.isdelete_bill_1=0)
						   and
						  ( V_bill_1.guid_costcenter in  (select guid from  dbo.fun_TB_COstcenter_Filter( @GUID_costcenter )   ) )
						 and
						  ( V_bill_2.guid_store_bill_2 in  (select guid from  dbo.fun_store_Filter( @guid_st )   ) )
						   and
						  ( V_bill_1.guid_Salesman in  (select guid from  dbo.fun_salesman_Filter( @GUID_Bransh )   ) )	
						   and
						  ( V_bill_1.guid_bransh in  (select guid from  dbo.fun_branch_Filter( @GUID_Bransh )   ) )					  						 
							and	 
						    (dbo.V_bill_1.DATE_BILL_1 BETWEEN CONVERT(date,  @dat1, 102) AND
						   CONVERT(date,  @dat2, 120)) ) tb

 ----------------------- ----------------------- ----------------------- ----------------------- -----------------------
 

  --select *,
 
  --(cASE WHEN  type_bill_number = 3   THEN -(qty*(price/Ratio_unit))-(qty*Average)   ELSE (qty*(price/Ratio_unit))-(qty*Average)  END)profit
  -- from #temp

 
 end
  

GO

------------------------------------------------------------------
  
 IF EXISTS(SELECT Name FROM SYS.Objects WHERE Object_ID = OBJECT_ID(N'Bill_profit') AND TYPE IN(N'P', N'PC'))
	DROP PROCEDURE [Bill_profit]
GO
 create proc  [dbo].[Bill_profit]
   @dat1 datetime='2017-10-07', ---='2017-10-07',
  @dat2 datetime='2022-10-07', ---='2019-10-07',
  @guid_st uniqueidentifier='00000000-0000-0000-0000-000000000000' ,
  @guid_mt uniqueidentifier='00000000-0000-0000-0000-000000000000' ,
  @guid_bransh uniqueidentifier='00000000-0000-0000-0000-000000000000',
@guid_costcenter uniqueidentifier ='00000000-0000-0000-0000-000000000000',
@guid_salesman uniqueidentifier ='00000000-0000-0000-0000-000000000000',
 @guid_Categorye uniqueidentifier  ='00000000-0000-0000-0000-000000000000',
 @idcurrncye uniqueidentifier='a36964c4-9e7e-45bb-8ae8-af4f5470f2a5',
 @CurRate float=1 
 as
 begin

 
 
 
 

 



   declare @tb_mt table(guid uniqueidentifier)
 if(@guid_mt  ='00000000-0000-0000-0000-000000000000')
 begin
 insert into @tb_mt select guid from TB_ITM
 end
  if(@guid_mt  !='00000000-0000-0000-0000-000000000000')
 begin
  INSERT  INTO @tb_mt  (guid)values(@guid_mt)
 
 end






 --drop table #temp

  declare @Log_company nvarchar(max)
,@NAMEcompany nvarchar(max)
,@PHONEcompany nvarchar(max)
,@MOBILEcompany nvarchar(max)
,@EMAILcompany nvarchar(max)
,@TaxNumbecompanyr nvarchar(max)
,@Notecompany nvarchar(max)
 ,@WEBcompany nvarchar(max)

SELECT top 1  @Log_company=[Log_company]
      ,@NAMEcompany=[NAME]
      ,@PHONEcompany=[PHONE]
      ,@MOBILEcompany=[MOBILE]
      ,@EMAILcompany=[EMAIL]
      ,@WEBcompany=[WEB]
      ,@TaxNumbecompanyr=[TaxNumber]
      ,@Notecompany=[Note]
      
  FROM [dbo].[Company]
 


 select GUID_BILL_1,  NAME_BILL1  , max(NUMBER_BILL_1)NUMBER_BILL_1,max(DATE_BILL_1)DATE_BILL_1,max(NameA_CUSTOMER)NameA_CUSTOMER,  
 max(  total_BILL_1)total_BILL_1,
						max(  disc_BILL_1)disc_BILL_1,
						max(  EXTEA_BILL_1)EXTEA_BILL_1,
						max(vat_BILL_1)vat_BILL_1,
						max(sup_total_BILL_1)sup_total_BILL_1,
 
(sum((cASE WHEN  type_bill_number = 3   THEN -(qty*(price/Ratio_unit))-(qty*Average)   ELSE (qty*(price/Ratio_unit))-(qty*Average)  END)))-max(disc_bill_2)+max(extra_bill_2) profit,
							 @Log_company  Log_company,
@NAMEcompany NAMEcompany,
@MOBILEcompany MOBILEcompany ,
@EMAILcompany EMAILcompany,
@TaxNumbecompanyr TaxNumbecompanyr,
@Notecompany Notecompany,
 @WEBcompany WEBcompany,
  @dat1 fromdate,
@dat2 todate

 from(

SELECT   dbo.V_bill_1.GUID_BILL_1,  V_bill_1.type_bill_number  ,   dbo.V_bill_1.NAME_BILL1,
 dbo.V_bill_1.NUMBER_BILL_1, 
 dbo.V_bill_1.DATE_BILL_1, 
 dbo.V_bill_1.NameA_CUSTOMER,
  dbo.V_bill_2.BARCODE_bill_2, 
                    V_bill_2.GUID_ITEME_bill_2, 
					   dbo.V_bill_2.code_iteme_bill_2 +'   '+ dbo.V_bill_2.nameA_iteme_bill_2 AS name_iteme,
						(V_bill_2.QTY_bill_2* V_bill_2.V_bill_2RatioUnit ) qty,
						 
						    (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then   (  dbo.FunINFIRST (GUID_ITEME_bill_2 , V_bill_1.DATE_BILL_1 )) when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then ( (  dbo.FunINFIRST (GUID_ITEME_bill_2 , V_bill_1.DATE_BILL_1 ))* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)Average,
						V_bill_2RatioUnit Ratio_unit,
						 
						   (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.PRICE_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.PRICE_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)price,						 
						    (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.disc_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.disc_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)disc_bill_2,
						 (case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.extra_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.extra_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)extra_bill_2,
						(case when V_bill_1.GUID_CURRENCY_bill_1=@idcurrncye  then  V_bill_2.VAT_bill_2 when  V_bill_1.GUID_CURRENCY_bill_1 !=@idcurrncye  then (V_bill_2.VAT_bill_2* V_bill_1.CURRENCY_VAL_BILL_1)/(@CurRate ) end)VAT_bill_2,
						   dbo.V_bill_2.VAT_R_bill_2,
						    V_bill_2.V_bill_2name_unit nameA_unit_bill_2,
							(select namea from TB_UNIT where guid = V_bill_2.unit1_bill2) name_unit1,
							 dbo.V_bill_2.NOTE_bill_2,
							  dbo.V_bill_1.PARENT_GUID_BILL_1,
							   dbo.V_bill_2.nameA_store_bill_2, 
							    dbo.V_bill_2.guid_store_bill_2, 
                             
						 TB_Category.code TB_CategoryCode,
						 TB_Category.nameA TB_CategorynameA,
						 V_bill_1.total_BILL_1,
						 V_bill_1.disc_BILL_1,
						 V_bill_1.EXTEA_BILL_1,
						  V_bill_1.vat_BILL_1,
						    V_bill_1.sup_total_BILL_1
						
 
 
FROM            dbo.V_bill_1 INNER JOIN
                         dbo.V_bill_2 ON dbo.V_bill_1.GUID_BILL_1 = dbo.V_bill_2.PARENT_GUID_bill_2
						 inner join TB_Category on TB_Category.Guid=V_bill_2.iteme_parentguid
 	

						  WHERE  (V_bill_1.ispost_bill_1=1)  
						  and  V_bill_1.type_bill_number in ( 2,3)
						  and (V_bill_1.isdelete_bill_1=0)
						     and
						  ( TB_Category.guid in   (select guid from  dbo.fun_category_Filter( @guid_Categorye )   ) )
						  and  (V_bill_1.ispost_bill_1=1)  and (V_bill_1.isdelete_bill_1=0)
						   and
						  ( V_bill_1.guid_costcenter in  (select guid from  dbo.fun_TB_COstcenter_Filter( @GUID_costcenter )   ) )
						 and
						  ( V_bill_2.guid_store_bill_2 in  (select guid from  dbo.fun_store_Filter( @guid_st )   ) )
						   and
						  ( V_bill_1.guid_Salesman in  (select guid from  dbo.fun_salesman_Filter( @GUID_Bransh )   ) )	
						   and
						  ( V_bill_1.guid_bransh in  (select guid from  dbo.fun_branch_Filter( @GUID_Bransh )   ) )					  						 
							and	 
						    (dbo.V_bill_1.DATE_BILL_1 BETWEEN CONVERT(date,  @dat1, 102) AND
						   CONVERT(date,  @dat2, 120))  ) tb
						   group by NAME_BILL1,GUID_BILL_1
 ----------------------- ----------------------- ----------------------- ----------------------- -----------------------
 

  --select *,
 
  --(cASE WHEN  type_bill_number = 3   THEN -(qty*(price/Ratio_unit))-(qty*Average)   ELSE (qty*(price/Ratio_unit))-(qty*Average)  END)profit
  -- from #temp

 
 end
                          
 

GO
 ------------------------------------------------------------------
							 
 
 

 