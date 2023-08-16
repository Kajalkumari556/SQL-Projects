--Import Data
select*from Practice..[Housing Data]

--Standardize date format
select SaleDate, CONVERT(date, SaleDate) as Date
from Practice..[Housing Data]

update [Housing Data]
set Date= CONVERT(date, SaleDate) 

 

UPDATE [Housing Data]
SET SalesDateConverted = CONVERT(date, SaleDate);

select*from Practice..[Housing Data]

--populate property address data
select fr.ParcelID, fr.PropertyAddress, se.ParcelID, se.PropertyAddress, ISNULL(fr.PropertyAddress,se.PropertyAddress) 
from Practice..[Housing Data] as fr
join Practice..[Housing Data] as se
	on fr.ParcelID=se.ParcelID
	and fr.[UniqueID ]<>se.[UniqueID ]
order by fr.PropertyAddress

Update fr
Set PropertyAddress=ISNULL(fr.PropertyAddress,se.PropertyAddress)
from Practice..[Housing Data] as fr
join Practice..[Housing Data] as se
	on fr.ParcelID=se.ParcelID
	and fr.[UniqueID ]<>se.[UniqueID ]


--Breaking out Address into individual Columns (Address, City, State)
select PropertyAddress
from Practice..[Housing Data]


SELECT 
    LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1) AS AddressPart1,
    RIGHT(PropertyAddress, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress)) AS AddressPart2
FROM Practice..[Housing Data];

ALTER TABLE [Housing Data]
ADD AddressPart1 nvarchar(max),
    AddressPart2 nvarchar(max);
UPDATE [Housing Data]
SET AddressPart1 = LEFT(PropertyAddress, CHARINDEX(',', PropertyAddress) - 1),
    AddressPart2 = RIGHT(PropertyAddress, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress));
SELECT * FROM Practice..[Housing Data]

--Change Y and N as Yes and No in Sold as Vacant Column
select distinct (SoldAsVacant), count(SoldAsVacant)
from Practice..[Housing Data]
Group by SoldAsVacant
order by SoldAsVacant

select SoldAsVacant,
	Case when SoldAsVacant='N' then 'No'
		when SoldAsVacant = 'Y' then 'Yes'
		Else SoldAsVacant
		End 
from Practice..[Housing Data]

update Practice..[Housing Data]
Set SoldAsVacant=Case when SoldAsVacant='N' then 'No'
		when SoldAsVacant = 'Y' then 'Yes'
		Else SoldAsVacant
		End 

select * from Practice..[Housing Data]
select distinct (SoldAsVacant), count(SoldAsVacant)
from Practice..[Housing Data]
Group by SoldAsVacant
order by SoldAsVacant

--Remove Duplicates

WITH rownumCTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY uniqueID
        ) AS row_num
    FROM Practice..[Housing Data]
)
SELECT *
FROM rownumCTE;

select * 
from rownumCTE
where row_num > 1 








