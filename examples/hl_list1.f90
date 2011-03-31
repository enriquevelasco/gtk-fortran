module l1_handlers
  use fgtk_h_widgets

  implicit none

  ! The widgets. (Strictly only those that need to be accessed
  ! by the handlers need to go here).

  type(c_ptr) :: ihwin,ihscrollcontain,ihlist, base, &
       & newline, qbut, dbut, dabut, jbox, jbox2, abut

contains
  subroutine my_destroy(widget, gdata) bind(c)
    type(c_ptr), value :: widget, gdata
    print *, "Exit called"
    call gtk_object_destroy(ihwin)
    call gtk_main_quit ()
  end subroutine my_destroy

  function list_select(list, gdata) result(res) bind(c)
    integer(kind=c_int) :: res
    type(c_ptr), value :: list, gdata

    integer, pointer :: fdata
    integer(kind=c_int) :: nsel
    integer(kind=c_int), dimension(:), allocatable :: selections

    res = FALSE
    if (c_associated(gdata)) then
       call c_f_pointer(gdata, fdata)
       nsel = f_gtk_list1_get_selections(NULL, selections, list)
       if (nsel == 0) return

       if (fdata == 0) then
          ! Find and print the selected row(s)
          print *, nsel,"Rows selected"
          print *, selections
          deallocate(selections)
       else    ! Delete the selected row
          call f_gtk_list1_rem(ihlist, selections(1))
          call gtk_toggle_button_set_active(dbut, FALSE)
          fdata = 0
       end if
    end if

  end function list_select

  function text_cr(widget, gdata) result(res) bind(c)
    integer(kind=c_int) :: res
    type(c_ptr), value :: widget, gdata

    integer, pointer :: fdata

    if (c_associated(gdata)) then
       call c_f_pointer(gdata, fdata)
       fdata = 1
    end if
    res=FALSE
  end function text_cr
  
  function b_click(widget, gdata) result(res) bind(c)
    integer(kind=c_int) :: res
    type(c_ptr), value :: widget, gdata

    integer, pointer :: fdata
    type(c_ptr) :: text
    integer(c_int16_t) :: ntext
    character(kind=c_char), dimension(:), pointer :: ftext

    if (c_associated(gdata)) then
       call c_f_pointer(gdata, fdata)
       if (fdata == 1) then
          ntext = gtk_entry_get_text_length(newline)
          text=gtk_entry_get_text(newline)
          call c_f_pointer(text, ftext, (/int(ntext,c_int)/))
          print *, ntext, "*",ftext(:ntext),"*"
          call f_gtk_list1_ins(ihlist, (/ftext(:ntext),cnull/))
          fdata = 0
          call gtk_entry_set_text(newline, ""//cnull)
       end if
    end if
    res = FALSE
  end function b_click

  function del_toggle(widget, gdata) result(res) bind(c)
    integer(kind=c_int) :: res
    type(c_ptr), value :: widget, gdata

    integer, pointer :: fdata

    if (c_associated(gdata)) then
       call c_f_pointer(gdata, fdata)
       fdata = gtk_toggle_button_get_active(widget)
    end if
    res = FALSE
  end function del_toggle

  function delete_all(widget, gdata) result(res) bind(c)
    integer(kind=c_int) :: res
    type(c_ptr), value :: widget, gdata
    
    call f_gtk_list1_rem(ihlist)
    res = FALSE
  end function delete_all

end module l1_handlers

program list1
  ! LIST1
  ! Demo of single column list

  use l1_handlers

  implicit none

  character(len=35) :: line
  integer :: i, ltr
  integer, target :: iappend=0, idel=0

  ! Initialize GTK+
  call gtk_init()

  ! Create a window that will hold the widget system
  ihwin=f_gtk_window('list demo'//cnull, destroy=c_funloc(my_destroy))

  ! Now make a column box & put it into the window
  base = gtk_vbox_new(FALSE, 0)
  call gtk_container_add(ihwin, base)

  ! Now make a single column list with multiple selections enabled
  ihlist = f_gtk_list1(ihscrollcontain, changed=c_funloc(list_select),&
       & data=c_loc(idel), multiple=TRUE, height=400, title="My list"//cnull)

  ! Now put 10 rows into it
  do i=1,10
     write(line,"('List entry number ',I0)") i
     ltr=len_trim(line)+1
     line(ltr:ltr)=cnull
     print *, line
     call f_gtk_list1_ins(ihlist, line)
  end do

  ! It is the scrollcontainer that is placed into the box.
  call gtk_box_pack_start_defaults(base, ihscrollcontain)

  ! Make row box put it in the column box and put an editable
  ! 1-line text widget and a button in it
  jbox = gtk_hbox_new(FALSE, 0)
  call gtk_box_pack_start_defaults(base, jbox)

  newline = f_gtk_entry(len=35, editable=TRUE, activate=c_funloc(text_cr), &
       & data=c_loc(iappend))
  call gtk_box_pack_start_defaults(jbox, newline)
  abut = f_gtk_button("Append"//cnull, clicked=c_funloc(b_click),&
       & data=c_loc(iappend))
  call gtk_box_pack_start_defaults(jbox, abut)

  ! Make a row box and put it in the main box
  jbox2 = gtk_hbox_new(FALSE, 0)
  call gtk_box_pack_start_defaults(base, jbox2)
  ! Make a checkbox button and put it in the row box
  dbut = f_gtk_check_button("Delete line"//cnull,&
       & toggled=c_funloc(del_toggle), initial_state=FALSE, &
       & data=c_loc(idel))
  call gtk_box_pack_start_defaults(jbox2, dbut)

  ! And a delete all button.
  dabut = f_gtk_button("Clear"//cnull, clicked=c_funloc(delete_all))
  call gtk_box_pack_start_defaults(jbox2, dabut)

  ! Also a quit button
  qbut = f_gtk_button("Quit"//cnull, clicked=c_funloc(my_destroy))
  call gtk_box_pack_start_defaults(base,qbut)

  ! realize the window

  call gtk_widget_show_all(ihwin)

  ! Event loop

  call gtk_main()

end program list1