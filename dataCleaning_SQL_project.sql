--Show entire table

select * from Nashvillehouse

--Having only date part in SaleDate

ALTER TABLE Nashvillehouse
ADD Sale_date_format date

UPDATE Nashvillehouse 
SET Sale_date_format=convert(date,SaleDate)

SELECT convert(date,SaleDate),Sale_date_format FROM Nashvillehouse

ALTER TABLE	Nashvillehouse
DROP column SaleDate

--Populating values for PropertyAddress that have NULL values

SELECT a.[UniqueID ],a.ParcelID,a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress) as Col
FROM Nashvillehouse a 
INNER JOIN Nashvillehouse b 
on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null
order by 1,4

UPDATE a 
SET a.propertyaddress=b.propertyaddress
FROM Nashvillehouse a 
INNER JOIN Nashvillehouse b 
on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
WHERE a.PropertyAddress is null


SELECt * from Nashvillehouse where PropertyAddress is null

--Seperating address elements in propertyaddress

SELECT propertyaddress, SUBSTRING(propertyaddress,1,charindex(',',propertyAddress) -1) as address,
SUBSTRING(propertyaddress,charindex(',',propertyAddress) +1,len(PropertyAddress)) as city
FROM Nashvillehouse

ALTER table Nashvillehouse
add propertaddress_address varchar(40)

ALTER table Nashvillehouse
add propertaddress_city varchar(20)

UPDATE Nashvillehouse
SET propertaddress_address=SUBSTRING(propertyaddress,1,charindex(',',propertyAddress) -1),
	propertaddress_city=SUBSTRING(propertyaddress,charindex(',',propertyAddress) +1,len(PropertyAddress))

SELECT propertaddress_address, propertaddress_city from Nashvillehouse


--Seperating address elements in owneraddress

SELECT owneraddress from Nashvillehouse

SELECT PARSENAME(REPLACE(owneraddress,',','.'),1) as state,
	   PARSENAME(REPLACE(owneraddress,',','.'),2) as city,
	   PARSENAME(REPLACE(owneraddress,',','.'),3) as address
FROM Nashvillehouse



ALTER table Nashvillehouse
add owneraddress_state varchar(15)

ALTER table Nashvillehouse
add owneraddress_city varchar(20)

ALTER table Nashvillehouse
add owneraddress_address varchar(40)

UPDATE Nashvillehouse
set owneraddress_state=PARSENAME(REPLACE(owneraddress,',','.'),1),
    owneraddress_city=PARSENAME(REPLACE(owneraddress,',','.'),2),
	owneraddress_address=PARSENAME(REPLACE(owneraddress,',','.'),3)


SELECT owneraddress, owneraddress_address, owneraddress_city, owneraddress_state from Nashvillehouse


--y to yes and n to no in SoldasVacant

select soldasvacant,count(soldasvacant) from nashvillehouse group by  SoldAsVacant

UPDATE Nashvillehouse
SET SoldAsVacant= case 
				  When soldasvacant='Y' then 'Yes'
				  when soldasvacant='N' then 'No'
				  else soldasvacant
				  end

select soldasvacant,count(soldasvacant) from nashvillehouse group by  SoldAsVacant


--Removing duplicates

SELECT * FROM (SELECT *, row_number () over( partition by parcelId,propertyaddress,saledate,saleprice,legalreference
							  order by uniqueID) row_num
FROM nashvillehouse) t  where t.row_num>1

--TO DELETE THE ROWS ABOVE ::

WITH r_num_cte AS(
SELECT *, row_number () over( partition by parcelId,propertyaddress,saledate,saleprice,legalreference
							  order by uniqueID) row_num
FROM nashvillehouse 
)
DELETE FROM r_num_cte where row_num>1


--Final table
Select * from Nashvillehouse