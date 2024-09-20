/*

Cleaning Data in SQL

*/

Select *
from PortfolioProject.dbo.Nashvillehousing

----------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.Nashvillehousing

Update Nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

------------------------------------------------------------------

--Populate Property Address data

Select *
From PortfolioProject.dbo.Nashvillehousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashvillehousing a
JOIN PortfolioProject.dbo.Nashvillehousing b	
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.Nashvillehousing a
JOIN PortfolioProject.dbo.Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




----------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 ) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1 )


ALTER TABLE Nashvillehousing
Add PropertySplicity Nvarchar(255);

Update Nashvillehousing
SET PropertySplicity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *

From PortfolioProject.dbo.Nashvillehousing




Select OwnerAddress

From PortfolioProject.dbo.Nashvillehousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProject.dbo.Nashvillehousing

ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE Nashvillehousing
Add OwnerSplitcity Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE Nashvillehousing
Add OwnerSplitstate Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitstate= PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *

From PortfolioProject.dbo.Nashvillehousing


----------------------------------------------------------------------------------------------------------------------------------------------------

-- change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortfolioProject.dbo.Nashvillehousing
group by SoldAsVacant
order by 2


Select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'YES'	
	  when SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
From PortfolioProject.dbo.Nashvillehousing

Update Nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



-----------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.Nashvillehousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PortfolioProject.dbo.Nashvillehousing



---------------------------------------------------------------------------------------------------------------------

-- Delete unused Columns

Select *
From PortfolioProject.dbo.Nashvillehousing


ALTER TABLE PortfolioProject.dbo.Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.Nashvillehousing
DROP COLUMN SaleDate