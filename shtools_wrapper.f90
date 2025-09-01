! shtools_wrapper.f90
module shtools_wrapper
  use ftypes
  use shtools, only: SHExpandDH, SHExpandDHC
  implicit none

contains

  subroutine compute_shcoeffs_cmplx(grid, nlat, nlon, lmax, alm) bind(C, name="compute_shcoeffs_cmplx")
    use iso_c_binding, only: c_int, c_double
    implicit none

    integer(c_int), intent(in) :: nlat, nlon
    real(c_double), dimension(nlat, nlon), intent(in) :: grid(nlat, nlon)
    complex(dp), dimension(nlat, nlon) :: grid_cdp(nlat, nlon)

    integer(c_int), intent(inout) :: lmax
    real(c_double), dimension(2, lmax+1, lmax+1), intent(out) :: alm(2, lmax+1, lmax+1)
    complex(dp), dimension(2, lmax+1, lmax+1) :: alm_cdp(2, lmax+1, lmax+1)

    integer(c_int) :: i
    integer(c_int) :: j

    integer(c_int) :: idx
    integer(c_int) :: l
    integer(c_int) :: m

    do i = 1, nlat
      do j = 1, nlon
        grid_cdp(i,j) = cmplx(grid(i,j), 0, kind=dp)
      end do
    end do

    call SHExpandDHC(grid_cdp, nlat, alm_cdp, lmax, 1, 1, 1)

    idx = 1
    do l = 1, lmax+1
      do m = 1, l+1
        alm(idx,  l,m) = real(alm_cdp(1, l+1, m+1), kind=c_double)
        alm(idx+1,l,m) = aimag(alm_cdp(1, l+1, m+1))
        idx = idx + 2
      end do
    end do
  end subroutine compute_shcoeffs_cmplx

  subroutine compute_shcoeffs_real(grid, nlat, nlon, lmax, alm) bind(C, name="compute_shcoeffs_real")
    use iso_c_binding, only: c_int, c_double
    implicit none

    integer(c_int), intent(in) :: nlat, nlon
    real(c_double), dimension(nlat, nlon), intent(in) :: grid(nlat, nlon)

    integer(c_int), intent(inout) :: lmax
    real(c_double), dimension(2, lmax+1, lmax+1), intent(out) :: alm(2, lmax+1, lmax+1)

    call SHExpandDH(grid, nlat, alm, lmax, 1, 1, 1)
  end subroutine compute_shcoeffs_real

end module shtools_wrapper
