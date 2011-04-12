! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by James Tappin
! Last modification: 03-30-2011

module gtk_hl
  ! A bunch of procedures to implement higher level creators for
  ! the gtk-fortran widgets. Some settings and operations are also
  ! provided for the more intricate widgets.
  !
  ! To date this is very incomplete.
  !
  ! Many ideas in this module were taken from the pilib gtk<->fortran
  ! interface.

  ! Currently included:
  ! hl_gtk_window_new: A top-level window.
  ! hl_gtk_button_new: A simple button
  ! hl_gtk_check_button_new: A check button
  ! hl_gtk_radio_button_new: A radio button with group.
  !     hl_gtk_radio_group_get_select: Which member of a radio group
  !     	is selected.
  !     hl_gtk_radio_group_set_select: Select a member of a radio group.
  ! hl_gtk_entry_new: A 1-line text box
  ! hl_gtk_list1_new: A single column list with indexing
  !     hl_gtk_list1_get_selections: Get the selected row(s) from a list.
  !     hl_gtk_list1_ins: Insert a row into a list
  !     hl_gtk_list1_rem: Delete a row from a list, or clear the list.
  ! hl_gtk_menu_new: Create a menubar.
  ! hl_gtk_menu_submenu: Add a submenu to a menu
  ! hl_gtk_menu_item: Add a button to a menu
  ! hl_gtk_progress_bar_new: A progress bar.
  ! hl_gtk_progress_bar_set: Set the value of a progress bar.
  ! hl_gtk_message_dialog_show

  ! To facilitate the automatic extraction of API information, there are
  ! 2 types of comment block that are extracted:
  !
  ! Blocks delimited by !* and !/ which provide a section header and
  ! an optional description for a group of widgets.
  !
  ! Block delimited by !+ and !- describe an individual routine.
  ! !+ should immediately precede the function or subroutine statement.
  ! The descriptive comments should come between that and the start of
  ! the declarations. The arguments are described in a colon-separated list
  ! with name: type : status : description.
  ! If there is any description following the table, then a line with just
  ! a ! character must terminate the table.

  ! The iso_c_binding & gtk modules are implicitly included in the
  ! gtk_sup -- speeds compilation to omit them here.
  ! use iso_c_binding
  ! use gtk
  use gtk_sup

  use gtk, only: gtk_box_pack_start, gtk_button_new,&
       & gtk_button_new_with_label, gtk_cell_renderer_set_alignment, gtk_cell_renderer&
       &_set_padding, gtk_cell_renderer_set_visible, gtk_cell_renderer_text_new, gtk_c&
       &heck_button_new, gtk_check_button_new_with_label, gtk_container_add, gtk_conta&
       &iner_set_border_width, gtk_dialog_add_button, gtk_dialog_get_content_area, gtk&
       &_dialog_new, gtk_dialog_run, gtk_editable_set_editable, gtk_entry_new, gtk_ent&
       &ry_set_activates_default, gtk_entry_set_max_length, gtk_entry_set_text, gtk_hb&
       &ox_new, gtk_label_new, gtk_list_store_append, gtk_list_store_clear, gtk_list_s&
       &tore_insert, gtk_list_store_newv, gtk_list_store_remove, gtk_list_store_set_va&
       &lue, gtk_menu_bar_new, gtk_menu_bar_set_pack_direction, gtk_menu_item_new, gtk&
       &_menu_item_new_with_label, gtk_menu_item_set_submenu, gtk_menu_new, gtk_menu_s&
       &hell_append, gtk_menu_shell_insert, gtk_orientable_set_orientation, gtk_progre&
       &ss_bar_new, gtk_progress_bar_pulse, gtk_progress_bar_set_fraction, &
       & gtk_progress_bar_set_pulse_step, gtk_progress_bar_set_t&
       &ext, gtk_radio_button_get_group, gtk_radio_button_new, gtk_radio_button_new_wi&
       &th_label, gtk_scrolled_window_new, gtk_scrolled_window_set_policy, gtk_separat&
       &or_menu_item_new, gtk_toggle_button_get_active, gtk_toggle_button_set_active, &
       &gtk_tree_model_get_iter, gtk_tree_model_get_value, gtk_tree_model_iter_n_child&
       &ren, gtk_tree_model_iter_next, gtk_tree_model_iter_nth_child, gtk_tree_path_fr&
       &ee, gtk_tree_selection_get_selected, gtk_tree_selection_get_selected_rows, gtk&
       &_tree_selection_set_mode, gtk_tree_view_append_column, gtk_tree_view_column_ad&
       &d_attribute, gtk_tree_view_column_new, gtk_tree_view_column_pack_start, gtk_tr&
       &ee_view_column_set_fixed_width, gtk_tree_view_column_set_max_width, gtk_tree_v&
       &iew_column_set_reorderable, gtk_tree_view_column_set_resizable, gtk_tree_view_&
       &column_set_sizing, gtk_tree_view_column_set_title, gtk_tree_view_get_model, gt&
       &k_tree_view_get_selection, gtk_tree_view_new, gtk_tree_view_new_with_model, gt&
       &k_vbox_new, gtk_widget_destroy, gtk_widget_set_sensitive, gtk_widget_set_size_&
       &request, gtk_widget_set_tooltip_text, gtk_widget_show, gtk_widget_show_all, gt&
       &k_window_new, gtk_window_set_default, gtk_window_set_default_size, gtk_window_&
       &set_modal, gtk_window_set_title, g_signal_connect, &
       & gtk_hscale_new, gtk_hscale_new_with_range, gtk_range_get_value, & ! Scales start
       &gtk_range_set_value, gtk_scale_set_digits, gtk_spin_button_get_value, gtk_spin&
       &_button_new, gtk_spin_button_new_with_range, gtk_spin_button_set_digits, gtk_s&
       &pin_button_set_numeric, gtk_spin_button_set_value, gtk_vscale_new, gtk_vscale_&
       &new_with_range, gtk_scale_set_draw_value, gtk_spin_button_set_wrap, & ! Scales end
       &gtk_text_buffer_delete, gtk_text_buffer_get_end_iter, gtk_text_buf& ! Text view start
       &fer_get_insert, gtk_text_buffer_get_iter_at_line, gtk_text_buffer_get_iter_at_&
       &line_offset, gtk_text_buffer_get_iter_at_mark, gtk_text_buffer_get_modified, g&
       &tk_text_buffer_get_selection_bound, gtk_text_buffer_get_selection_bounds, gtk_&
       &text_buffer_get_start_iter, gtk_text_buffer_get_text, gtk_text_buffer_insert, &
       &gtk_text_buffer_insert_at_cursor, gtk_text_buffer_new, gtk_text_buffer_set_mod&
       &ified, gtk_text_buffer_set_text, gtk_text_iter_forward_char, gtk_text_iter_for&
       &ward_chars, gtk_text_iter_forward_line, gtk_text_iter_forward_lines, gtk_text_&
       &iter_get_line, gtk_text_iter_get_line_offset, gtk_text_view_get_buffer, gtk_te&
       &xt_view_new, gtk_text_view_new_with_buffer, gtk_text_view_set_editable, gtk_text_iter_get_offset, &
       & TRUE, FALSE, &
       & GTK_WINDOW_TOPLEVEL, GTK_POLICY_AUTOMATIC, GTK_TREE_VIEW_COLUMN_FIXED, &
       & GTK_SELECTION_MULTIPLE, GTK_PACK_DIRECTION_LTR, GTK_BUTTONS_NONE, &
       & GTK_BUTTONS_OK, GTK_BUTTONS_CLOSE, GTK_BUTTONS_CANCEL, GTK_BUTTONS_YES_NO, &
       & GTK_BUTTONS_OK_CANCEL, GTK_RESPONSE_OK, GTK_RESPONSE_CLOSE, GTK_RESPONSE_CANCEL, &
       & GTK_RESPONSE_YES, GTK_RESPONSE_NO, GTK_RESPONSE_NONE, &
!       & gtk_progress_bar_set_orientation, gtk_box_pack_start_defaults, &
!       &GTK_PROGRESS_LEFT_TO_RIGHT, GTK_PROGRESS_BOTTOM_TO_TOP, &
!       & GTK_PROGRESS_TOP_TO_BOTTOM, GTK_PROGRESS_RIGHT_TO_LEFT
! Replace the last 2 lines with the next one for GTK3
       & GTK_ORIENTATION_VERTICAL, GTK_ORIENTATION_HORIZONTAL, &
       & gtk_progress_bar_set_inverted, gtk_progress_bar_set_show_text

  use g, only: alloca, g_list_foreach, g_list_free, g_list_length, g_list_nth, g_&
       &list_nth_data, g_slist_length, g_slist_nth, g_slist_nth_data, g_value_get_int,&
       & g_value_init, g_value_set_int, g_value_set_static_string

  use iso_c_binding

  implicit none

  ! A progress bar value can be given as a fraction or m of n
  interface hl_gtk_progress_bar_set
     module procedure  hl_gtk_progress_bar_set_f
     module procedure  hl_gtk_progress_bar_set_ii
  end interface hl_gtk_progress_bar_set

! A slider or a spin button can use integers or floats for its settings.
  interface hl_gtk_slider_new
     module procedure hl_gtk_slider_flt_new
     module procedure hl_gtk_slider_int_new
  end interface hl_gtk_slider_new
  interface hl_gtk_slider_set_value
     module procedure hl_gtk_slider_set_flt
     module procedure hl_gtk_slider_set_int
  end interface hl_gtk_slider_set_value

  interface hl_gtk_spin_button_new
     module procedure hl_gtk_spin_button_flt_new
     module procedure hl_gtk_spin_button_int_new
  end interface hl_gtk_spin_button_new
  interface hl_gtk_spin_button_set_value
     module procedure hl_gtk_spin_button_set_flt
     module procedure hl_gtk_spin_button_set_int
  end interface hl_gtk_spin_button_set_value
  
contains

  !*
  ! Window
  !/
  !+
  function hl_gtk_window_new(title, destroy, delete_event, data_destroy, &
       & data_delete_event, border, wsize, sensitive) result(win)
    ! Higher-level interface to make a gtk_window
    !
    ! TITLE: String: optional: Title for the window
    ! DESTROY: c_funptr: optional: Callback for the "destroy" signal
    ! DELETE_EVENT: c_funptr: optional: Callback for the "delete-event" signal
    ! DATA_DESTROY: c_ptr: optional: Data to be passed to the destroy
    ! 		signal handler
    ! DATA_DELETE_EVENT: c_ptr: optional: Data to be passed to the
    ! 		delete_event signal handler
    ! BORDER: integer: optional: Size of the window border
    ! WSIZE: integer(2): optional: Size of the window
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: win
    character(kind=c_char), dimension(*), intent(in), optional :: title
    type(c_funptr), optional :: destroy, delete_event
    type(c_ptr), optional :: data_destroy, data_delete_event
    integer, optional, intent(in) :: border
    integer, optional, intent(in), dimension(2) :: wsize
    integer(kind=c_int), intent(in), optional :: sensitive

    win = gtk_window_new (GTK_WINDOW_TOPLEVEL)
    call gtk_window_set_title(win, title)

    if (present(border)) call gtk_container_set_border_width(win, border)
    if (present(wsize)) &
         & call gtk_window_set_default_size(win, wsize(1), wsize(2))

    if (present(delete_event)) then
       if (present(data_delete_event)) then
          call g_signal_connect(win, "delete-event"//CNULL, delete_event, &
               & data_delete_event)
       else
          call g_signal_connect(win, "delete-event"//CNULL, delete_event)
       end if
    end if

    if (present(destroy)) then
       if (present(data_destroy)) then
          call g_signal_connect(win, "destroy"//CNULL, destroy, &
               & data_destroy)
       else
          call g_signal_connect(win, "destroy"//CNULL, destroy)
       end if
    end if

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(win, sensitive)

  end function hl_gtk_window_new

  !*
  ! Buttons
  !/
  !+
  function hl_gtk_button_new(label, clicked, data, tooltip, sensitive) &
       & result(but)
    ! Higher-level button
    !
    ! LABEL: string: required: The label on the button
    ! CLICKED: c_funptr: optional: callback routine for the "clicked" signal
    ! DATA: c_ptr: optional: Data to be passed to the clicked callback
    ! TOOLTIP: string: optional: tooltip to be displayed when the pointer
    ! 		is held over the button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: clicked
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive

    but=gtk_button_new_with_label(label)

    if (present(clicked)) then
       if (present(data)) then
          call g_signal_connect(but, "clicked"//CNULL, &
               & clicked, data)
       else
          call g_signal_connect(but, "clicked"//CNULL, &
               & clicked)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)
    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_button_new

  !+
  function hl_gtk_check_button_new(label, toggled, data, tooltip, &
       & initial_state, sensitive) result(but)
    ! Higher level check box.
    !
    ! LABEL: string: required:  The label on the button.
    ! TOGGLED: c_funptr: optional: Callback function for the "toggled" signal.
    ! DATA: c_ptr: optional: Data to pass to/from the toggled callback.
    ! TOOLTIP: string: optional: A tooltip for the check_button.
    ! INITIAL_STATE: integer: optional: set the initial state of the
    !               check_button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: initial_state
    integer(kind=c_int), intent(in), optional :: sensitive

    but = gtk_check_button_new_with_label(label)

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//cnull, toggled, data)
       else
          call g_signal_connect(but, "toggled"//cnull, toggled)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(initial_state)) &
         & call gtk_toggle_button_set_active(but, initial_state)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_check_button_new

  !+
  function hl_gtk_radio_button_new(group, label, toggled, data, tooltip, &
       & sensitive) result(but)
    ! Radio button
    !
    ! GROUP: c_ptr: required: The group to which the button belongs.
    ! 		This is an INOUT argument so it must be a variable
    ! 		of type(c_ptr). To start a new group (menu) initialize
    ! 		the variable to NULL, to add a new button use the value
    ! 		returned from the last call to hl_gtk_radio_button_new. This
    ! 		is the variable which you use to do things like setting the
    ! 		selection.
    ! LABEL: string: required: The label for the button.
    ! TOGGLED: c_funptr: optional: call back to be executed when the
    ! 		button is toggled
    ! DATA: c_ptr: optional: Data to pass to/from the "toggled" callback.
    ! TOOLTIP: string: optional: A tooltip for the radio button
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: but
    type(c_ptr), intent(inout) :: group
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive

    but = gtk_radio_button_new_with_label(group, label)
    group = gtk_radio_button_get_group(but)

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//cnull, toggled, data)
       else
          call g_signal_connect(but, "toggled"//cnull, toggled)
       end if
    end if
    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_radio_button_new

  !+
  subroutine hl_gtk_radio_group_set_select(group, index)
    ! Set the indexth button of a radio group
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    ! INDEX: integer: required: The index of the button to set
    ! 		(starting from the first as 0).
    !-

    type(c_ptr), intent(in) :: group
    integer(kind=c_int), intent(in) :: index

    integer(kind=c_int) :: nbuts
    type(c_ptr) :: datan

    nbuts = g_slist_length(group)

    ! Note that GROUP actually points to the last button added and to the
    ! group of the next to last & so on

    datan= g_slist_nth_data(group, nbuts-index-1)
    call gtk_toggle_button_set_active(datan, TRUE)

  end subroutine hl_gtk_radio_group_set_select

  !+
  function hl_gtk_radio_group_get_select(group) result(index)
    ! Find the selected button in a radio group.
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    !-

    integer(kind=c_int) :: index
    type(c_ptr), intent(in) :: group

    integer(kind=c_int) :: nbuts, i
    type(c_ptr) :: but

    nbuts = g_slist_length(group)
    index=-1

    do i = 1, nbuts
       but = g_slist_nth_data(group, nbuts-i)
       if (.not. c_associated(but)) exit

       if (gtk_toggle_button_get_active(but)==TRUE) then
          index = i-1
          return
       end if
    end do
  end function hl_gtk_radio_group_get_select

  !*
  ! Text Entry
  !/

  !+
  function hl_gtk_entry_new(len, editable, activate, data, tooltip, value, &
       & sensitive) result(entry)
    ! Higher level text entry box
    !
    ! LEN: integer: optional: The maximum length of the entry field.
    ! EDITABLE: boolean: optional: whether the entry box can be edited
    ! 		by the user
    ! ACTIVATE: c_funptr: optional: Callback function for the "activate" signal
    ! DATA: c_ptr: optional: Data to be passed to the activate callback
    ! TOOLTIP: string: optional: tooltip to be displayed when the pointer
    ! 		is held over the button.
    ! VALUE: string: optional: An initial value for the entry box.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    !-

    type(c_ptr) :: entry
    integer, intent(in), optional :: len
    integer(c_int), intent(in), optional :: editable
    type(c_funptr), optional :: activate
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip, value
    integer(kind=c_int), intent(in), optional :: sensitive

    entry = gtk_entry_new()
    call gtk_entry_set_activates_default(entry, TRUE)

    if (present(len)) call gtk_entry_set_max_length(entry, len)

    if (present(editable)) &
         & call gtk_editable_set_editable(entry, editable)

    if (present(activate)) then
       if (present(data)) then
          call g_signal_connect(entry, &
               & "activate"//CNULL, activate, data)
       else
          call g_signal_connect(entry, &
               & "activate"//CNULL, activate)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(entry, tooltip)

    if (present(value)) call gtk_entry_set_text(entry, value)
    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(entry, sensitive)

  end function hl_gtk_entry_new

  !*
  ! List1
  ! This is a single column list based on the GtkTreeView widget system.
  !/
  !+
  function hl_gtk_list1_new(scroll, width, changed, data, multiple, &
       & sensitive, tooltip, title, height) result(list)
    ! A single column selectable list based on the GTK Tree View
    !
    ! SCROLL: c_ptr: required: The scroll box containing the list
    ! 		(used for packing etc.)
    ! WIDTH: integer: optional: The width of the displayed column.
    ! CHANGED: c_funptr: optional: Callback function for the "changed"
    !           signal to the associated selection object.
    ! DATA: c_ptr: optional: Data to be passed to/from the callback.
    ! MULTIPLE: boolean: optional: Whether multiple selections are allowed.
    ! SENSITIVE: boolean: optional: Whether the widget is intially sensitive.
    ! TOOLTIP: string: optional: Tooltip for the widget
    ! TITLE: string: optional: Title for the visible column.
    ! HEIGHT: integer: optional: The height of the display (this is
    !            actually the height of the scroll box).
    !-

    type(c_ptr) :: list
    type(c_ptr), intent(out) :: scroll
    integer(kind=c_int), intent(in), optional :: width
    type(c_funptr), intent(in), optional :: changed
    type(c_ptr), intent(in), optional :: data
    integer(kind=c_int), intent(in),  optional :: multiple, sensitive
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip, title
    integer(kind=c_int), intent(in), optional :: height

    type(c_ptr), target :: renderer, column, select, model
    integer(kind=c_int) :: nc
    integer(kind=type_kind), target, dimension(2) :: types

    ! Create list storage with 2 colums (one is a dummy, to provide an index)

    types = (/ g_type_int, g_type_string /)
    model = gtk_list_store_newv(2, c_loc(types))

    ! Create visual list inside a scrollbar container
    scroll = gtk_scrolled_window_new(NULL, NULL)
    call gtk_scrolled_window_set_policy(scroll, GTK_POLICY_AUTOMATIC, &
         & GTK_POLICY_AUTOMATIC)
    list = gtk_tree_view_new_with_model(model)
    call gtk_container_add(scroll, list)

    ! Insert index column (invisible)
    renderer = gtk_cell_renderer_text_new()
    call gtk_cell_renderer_set_visible(renderer, FALSE)
    column = gtk_tree_view_column_new()
    call gtk_tree_view_column_pack_start(column, renderer, FALSE)
    call gtk_tree_view_column_set_title(column, "#"//cnull)
    call gtk_tree_view_column_add_attribute(column, renderer, &
         & "text"//CNULL, 0)
    nc = gtk_tree_view_append_column(list, column)
    call gtk_tree_view_column_set_sizing (column,GTK_TREE_VIEW_COLUMN_FIXED)
    call gtk_tree_view_column_set_max_width(column,0)

    ! Insert (visible) column

    renderer = gtk_cell_renderer_text_new()
    column = gtk_tree_view_column_new()
    call gtk_tree_view_column_pack_start(column, renderer, FALSE)
    call gtk_cell_renderer_set_alignment(renderer, 0., 0.)
    call gtk_cell_renderer_set_padding(renderer, 0, 0)
    if (present(title)) call gtk_tree_view_column_set_title(column, title)
    call gtk_tree_view_column_add_attribute(column, renderer, &
         & "text"//CNULL, 1)
    nc = gtk_tree_view_append_column(list, column)

    call gtk_tree_view_column_set_reorderable(column, FALSE)

    ! Set sizes if requested. Note that the vertical size is set with the
    ! scrollable window.
    if (present(width)) then
       call gtk_tree_view_column_set_sizing (column, GTK_TREE_VIEW_COLUMN_FIXED)
       call gtk_tree_view_column_set_fixed_width(column, width)
    end if
    if (present(height)) call gtk_widget_set_size_request(scroll,0,height)

    call gtk_tree_view_column_set_resizable(column,TRUE)

    ! The event handler is attached to the selection object, as is
    ! the multiple selection property.

    select = gtk_tree_view_get_selection(list)

    if (present(multiple)) then
       if (multiple == TRUE) &
            & call gtk_tree_selection_set_mode(select, GTK_SELECTION_MULTIPLE)
    end if

    if (present(changed)) then
       if (present(data)) then
          call g_signal_connect(select, "changed"//cnull, changed, data)
       else
          call g_signal_connect(select, "changed"//cnull, changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(list, tooltip)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(list, sensitive)

  end function hl_gtk_list1_new

  !+
  subroutine hl_gtk_list1_ins(list, text, row)
    ! Insert a row into a list
    !
    ! LIST: c_ptr: required: The list to insert to.
    ! TEXT: string: required: The text to insert.
    ! ROW: integer: optional: The row at which to insert the text
    ! 		(omit to append)
    !-

    type(c_ptr), intent(in) :: list
    character(kind=c_char), dimension(*), intent(in), target :: text
    integer(kind=c_int), intent(in), optional :: row

    integer(kind=c_int), target :: i, nrow
    integer(kind=c_int) :: valid

    type(c_ptr) :: store, val
    type(gtktreeiter), target :: iter
    type(gvalue), target :: vali, valt

    ! Get list storage
    store = gtk_tree_view_get_model(list)

    ! Insert row
    if (present(row)) then
       call gtk_list_store_insert(store, c_loc(iter), row)
       nrow = row
    else
       nrow=gtk_tree_model_iter_n_children (store, NULL);
       call gtk_list_store_append(store, c_loc(iter));
    end if

    ! Set value
    val = c_loc(vali)
    val=g_value_init(val, g_type_int)
    call g_value_set_int(c_loc(vali), nrow)
    call gtk_list_store_set_value(store, c_loc(iter), 0, val)
    val = c_loc(valt)
    val=g_value_init(val, g_type_string)
    call g_value_set_static_string(c_loc(valt), text)
    call gtk_list_store_set_value(store, c_loc(iter), 1, val)

    ! reset the indices for the rest of the list
    if (present(row)) then
       i = row
       do
          valid = gtk_tree_model_iter_next(store, c_loc(iter))
          if (valid == FALSE) exit
          i = i+1
          call gtk_list_store_set_value(store, c_loc(iter), 0, c_loc(i))
       end do
    end if
  end subroutine hl_gtk_list1_ins

  !+
  subroutine hl_gtk_list1_rem(list, row)
    ! Remove a row or clear a list
    !
    ! LIST: c_ptr: required: The list to modify
    ! ROW: integer: optional: The row to remove, if absent clear the list
    !-

    type(c_ptr), intent(in) :: list
    integer(kind=c_int), optional, intent(in) :: row

    integer(kind=c_int), target :: i
    integer(kind=c_int) :: valid
    type(c_ptr) :: store, val
    type(gtktreeiter), target :: iter
    type(gvalue), target :: vali

    ! Get list store
    store = gtk_tree_view_get_model(list)

    ! If 2 arguments, then remove a row
    if (present(row)) then
       valid = gtk_tree_model_iter_nth_child(store, c_loc(iter), NULL, row)
       if (valid==FALSE) return

       valid = gtk_list_store_remove(store, c_loc(iter))
       if (valid==TRUE) then   ! Not the last element
          i = row
          val = c_loc(vali)
          val = g_value_init(val, g_type_int)
          do
             call g_value_set_int(val, i)
             call gtk_list_store_set_value(store, c_loc(iter), 0, val)
             valid=gtk_tree_model_iter_next(store, c_loc(iter));
             if (valid==FALSE) exit
             i=i+1
          end do
       end if

    else   ! 1 argument clear the whole list
       call gtk_list_store_clear(store)
    end if
  end subroutine hl_gtk_list1_rem

  !+
  function hl_gtk_list1_get_selections(list, indices, selection) result(count)
    ! Get the indices of the selected rows
    !
    ! LIST: c_ptr: required: The list whose selections are to be found.
    ! INDICES: integer: optional: An allocatable array to return the
    ! 		list of selections. (If count = 0 it will not be allocated).
    ! 		If this argument is not given, then the number of
    ! 		selected rows is returned.
    ! SELECTION: c_ptr: optional: A selection. If this is given then LIST
    !           is ignored. This is most often used in the callback routine
    !           for the changed signal when that needs to find which element(s)
    !           are selected.
    !
    ! Returns the number of selections.
    !-

    integer(kind=c_int) :: count
    type(c_ptr), intent(in) :: list
    integer(kind=c_int), dimension(:), allocatable, target, &
         & intent(out), optional :: indices
    type(c_ptr), optional :: selection

    type(c_ptr) :: slist, vselection
    type(c_ptr), target :: model
    integer(kind=c_int) :: i
    type(c_ptr) :: cindex
    integer(kind=c_int) :: valid
    type(gtktreeiter), target :: iter
    type(gvalue), target :: val

    if (present(selection)) then
       vselection = selection
    else
       vselection = gtk_tree_view_get_selection(list)
    end if

    slist = gtk_tree_selection_get_selected_rows(vselection, &
         & c_loc(model))

    ! If no selections, then set the count to 0 and return
    if (.not. c_associated(slist)) then
       count=0
       return
    end if

    ! Determine how many rows are selected. Then if no output list was
    ! supplied, return, otherwise go on and make a list.
    count = g_list_length(slist)
    if (.not. present(indices)) return

    allocate(indices(count))

    ! For each of the elements in the selection list, find its index
    ! from the hidden first column
    do i = 1, count
       valid = gtk_tree_model_get_iter(model, c_loc(iter), &
            & g_list_nth_data(slist, i-1))
       call gtk_tree_model_get_value(model, c_loc(iter), 0, c_loc(val))
       indices(i) = g_value_get_int(c_loc(val))
       call clear_gvalue(val)
    end do

    ! Free the selection list.
    call g_list_foreach(slist, c_funloc(gtk_tree_path_free), NULL)
    call g_list_free(slist)

  end function hl_gtk_list1_get_selections

  !*
  ! Pulldown Menu
  !/
  !+
  function hl_gtk_menu_new(orientation) result(menu)
    ! Menu initializer (mainly for consistency)
    !
    ! ORIENTATION: integer: optional: Whether to lay out the top level
    ! 		horizontaly or vertically.
    !-

    type(c_ptr) :: menu
    integer(kind=c_int), intent(in), optional :: orientation

    integer(kind=c_int) :: orient
    if (present(orientation)) then
       orient= orientation
    else
       orient = GTK_PACK_DIRECTION_LTR
    end if

    menu = gtk_menu_bar_new()
    call gtk_menu_bar_set_pack_direction (menu, orient)

  end function hl_gtk_menu_new

  !+
  function hl_gtk_menu_submenu_new(menu, label, tooltip, pos) result(submenu)
    ! Make a submenu node
    !
    ! MENU: c_ptr: required:  The parent of the submenu
    ! LABEL: string: required: The label of the submenu
    ! TOOLTIP: string: optional: A tooltip for the submenu.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    !-

    type(c_ptr) :: submenu
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in) :: label
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional :: pos

    type(c_ptr) :: item

    ! Create a menu item
    item = gtk_menu_item_new_with_label(label)

    ! Create a submenu and attach it to the item
    submenu = gtk_menu_new()
    call  gtk_menu_item_set_submenu(item, submenu)

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)

  end function hl_gtk_menu_submenu_new

  !+
  function hl_gtk_menu_item_new(menu, label, activate, data, tooltip, pos) &
       & result(item)
    ! Make a menu item or separator
    !
    ! MENU: c_ptr: required: The parent menu.
    ! LABEL: string: optional: The label for the menu, if absent then insert
    ! 		a separator.
    ! ACTIVATE: c_funptr: optional: The callback function for the
    ! 		activate signal
    ! DATA: c_ptr: optional: Data to pass to the callback.
    ! TOOLTIP: string: optional: A tooltip for the menu item.
    ! POS: integer: optional: The position at which to insert the item
    ! 		(omit to append)
    !-

    type(c_ptr) ::  item
    type(c_ptr) :: menu
    character(kind=c_char), dimension(*), intent(in), optional :: label
    type(c_funptr), optional :: activate
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), optional :: pos

    ! Create the menu item
    if (present(label)) then
       item = gtk_menu_item_new_with_label(label)
    else
       item = gtk_separator_menu_item_new()
    end if

    ! Insert it to the parent
    if (present(pos)) then
       call gtk_menu_shell_insert(menu, item, pos)
    else
       call gtk_menu_shell_append(menu, item)
    end if

    ! If present, connect the callback
    if (present(activate)) then
       if (.not. present(label)) then
          print *, "HL_GTK_MENU_ITEM: Cannot connect a callback to a separator"
          return
       end if

       if (present(data)) then
          call g_signal_connect(item, "activate"//cnull, activate, data)
       else
          call g_signal_connect(item, "activate"//cnull, activate)
       end if
    end if

    ! Attach a tooltip
    if (present(tooltip)) call gtk_widget_set_tooltip_text(item, tooltip)
  end function hl_gtk_menu_item_new

  !*
  ! Progress Bar
  !/

  !+
  function hl_gtk_progress_bar_new(vertical, reversed, step) result(bar)
    ! Intializer for a progress bar
    !
    ! ORIENTATION: integer: optional: The orientation of the bar.
    ! STEP: double: optional: The fractional step to advance when
    ! 		pulsing the bar
    !-

    type(c_ptr) :: bar
    integer(kind=c_int), optional :: vertical, reversed
    real(kind=c_double), optional :: step

    integer(kind=c_int) :: orientation

    bar = gtk_progress_bar_new()

    ! GTK2 version
!    orientation = GTK_PROGRESS_LEFT_TO_RIGHT
!    if (present(vertical)) then
!       if (vertical == TRUE) orientation = GTK_PROGRESS_BOTTOM_TO_TOP
!       if (present(reversed)) then
!          if (reversed == TRUE) orientation = GTK_PROGRESS_TOP_TO_BOTTOM
!       end if
!    else if (present(reversed)) then
!       if (reversed == TRUE) orientation = GTK_PROGRESS_RIGHT_TO_LEFT
!    end if
!    call gtk_progress_bar_set_orientation(bar, orientation)
    ! end GTK2 version
    ! GTK3 version
    if (present(vertical)) then
       if (vertical == TRUE) then
          call gtk_orientable_set_orientation (bar, &
               & GTK_ORIENTATION_VERTICAL)
       else
          call gtk_orientable_set_orientation (bar, &
               & GTK_ORIENTATION_HORIZONTAL)
       end if
    end if

    if (present(reversed)) call gtk_progress_bar_set_inverted(bar, reversed)
    ! end GTK3 version

    if (present(step)) &
         & call gtk_progress_bar_set_pulse_step(bar, step)

  end function hl_gtk_progress_bar_new

  !+
  subroutine hl_gtk_progress_bar_set_f(bar, val, string, text)
    ! Set the value of a progress bar (fraction or pulse)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: double: optional: The value to set. If absent, the bar is pulsed
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar
    !-

    type(c_ptr) :: bar
    real(kind=c_double), optional :: val
    integer(kind=c_int), optional :: string
    ! character(kind=c_char), dimension(*), intent(in), optional :: text
    character(len=*), intent(in), optional:: text

    real(kind=c_double) :: frac
    character(len=50) :: sval

    ! If no value given pulse the bar
    if (.not. present(val)) then
       call gtk_progress_bar_pulse(bar)
    else
       ! Determine the fraction to fill & fill it
       call gtk_progress_bar_set_fraction(bar, val)
    end if

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//cnull)
       call gtk_progress_bar_set_show_text(bar, TRUE)
    else if (present(string)) then
       if (string == FALSE .or. .not. present(val)) return
       ! Otherwise we display a percentage
       write(sval, "(F5.1,'%')") val*100.

       call gtk_progress_bar_set_text (bar, trim(sval)//cnull)
       call gtk_progress_bar_set_show_text(bar, TRUE)
    else
       call gtk_progress_bar_set_show_text(bar, FALSE)
    end if
  end subroutine hl_gtk_progress_bar_set_f

  !+
  subroutine hl_gtk_progress_bar_set_ii(bar, val, maxv, string, text)
    ! Set the value of a progress bar (n of m)
    !
    ! BAR: c_ptr: required: The bar to set
    ! VAL: int: required: The value to set.
    ! MAXV: int: required: The maximum value for the bar
    ! STRING: boolean: optional: Whether to put a string on the bar.
    ! TEXT: string: optional: Text to put in the bar, (overrides STRING)
    !
    ! This routine is normally accessed via the generic interface
    ! hl_gtk_progress_bar
    !-

    type(c_ptr) :: bar
    integer(kind=c_int) :: val, maxv
    integer(kind=c_int), optional :: string
    !    character(kind=c_char), dimension(*), intent(in), optional :: text
    character(len=*), intent(in), optional:: text
    real(kind=c_double) :: frac
    character(len=50) :: sval

    frac = real(val,c_double)/real(maxv,c_double)
    call gtk_progress_bar_set_fraction(bar, frac)

    ! If annotation is needed, add it.
    if (present(text)) then
       call gtk_progress_bar_set_text (bar, text//cnull)
       call gtk_progress_bar_set_show_text(bar, TRUE)
    else if (present(string)) then
       if (string == FALSE) return
       ! Otherwise we display n or m
       write(sval, "(I0,' of ',I0)") val, maxv
       call gtk_progress_bar_set_text (bar, trim(sval)//cnull)
       call gtk_progress_bar_set_show_text(bar, TRUE)
    else
       call gtk_progress_bar_set_show_text(bar, TRUE)
    end if
  end subroutine hl_gtk_progress_bar_set_ii

  !*
  ! Dialogue
  ! The message dialogue provided is here because, the built-in message
  ! dialogue GtkMessageDialog cannot be created without calling variadic
  ! functions which are not compatible with Fortran, therefore this is
  ! based around the plain GtkDialog family. 
  !/

  !+
  function hl_gtk_message_dialog_show(message, button_set, title) &
       & result(resp)
    ! A DIY version of the message dialogue, needed because both creators
    ! for the built in one are variadic and so not callable from Fortran.
    !
    ! MESSAGE: string(n): required: The message to display. Since this is
    ! 		a string array, the CNULL terminations are provided internally
    ! BUTTON_SET: integer: required: The set of buttons to display
    ! TITLE: string: optional: Title for the window.
    !
    ! The return value is the response code, not the widget.
    !-

    integer(kind=c_int) :: resp
    character(len=*), dimension(:), intent(in) :: message
    integer(kind=c_int), intent(in) :: button_set
    character(kind=c_char), dimension(*), intent(in), optional :: title

    type(c_ptr) :: dialog, content, junk
    integer :: i

    ! Create the dialog window and make it modal.

    dialog=gtk_dialog_new()
    call gtk_window_set_modal(dialog, TRUE)
    if (present(title)) call gtk_window_set_title(dialog, title)

    ! Get the content area and put the message in it.
    content = gtk_dialog_get_content_area(dialog)

    do i = 1, size(message)
       junk = gtk_label_new(trim(message(i))//cnull)
       call gtk_box_pack_start(content, junk, TRUE, TRUE, 0)
    end do

    select case (button_set)
    case (GTK_BUTTONS_NONE)
    case (GTK_BUTTONS_OK)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_OK, GTK_RESPONSE_OK)
    case (GTK_BUTTONS_CLOSE)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CLOSE, &
            & GTK_RESPONSE_CLOSE)
    case (GTK_BUTTONS_CANCEL)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CANCEL, &
            & GTK_RESPONSE_CANCEL)
    case (GTK_BUTTONS_YES_NO)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_YES, GTK_RESPONSE_YES)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_NO, GTK_RESPONSE_NO)
    case (GTK_BUTTONS_OK_CANCEL)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_OK, GTK_RESPONSE_OK)
       junk = gtk_dialog_add_button(dialog, GTK_STOCK_CANCEL, &
            & GTK_RESPONSE_CANCEL)
    case default
       call gtk_widget_destroy(dialog)
       resp = GTK_RESPONSE_NONE
       return
    end select

    call gtk_widget_show_all (dialog)
    resp = gtk_dialog_run(dialog)
    call gtk_widget_destroy(dialog)

  end function hl_gtk_message_dialog_show

  !*
  ! Box
  ! A simplified way to make vertical or horizontal boxes
  ! This was added because the gtk_box_pack_start_defaults
  ! procedure is removed from GTK3.x
  !/
  !+
  function hl_gtk_box_new(horizontal, homogeneous, spacing) result(box)
    ! Generic packing box
    !
    ! HORIZONTAL: boolean: optional: Set to TRUE to make a row box. FALSE or
    !		absent implies a column box.
    ! HOMOGENEOUS: boolean: optional: If set to TRUE then all children are
    ! 		the same size, FALSE or absent allows each widget to take its
    ! 		natural size.
    ! SPACING: c_int: optional: Set the space between children.
    !-

    type(c_ptr) :: box
    integer(kind=c_int), intent(in), optional :: horizontal, homogeneous
    integer(kind=c_int), intent(in), optional :: spacing

    integer(kind=c_int) :: grid, space

    if (present(homogeneous)) then
       grid = homogeneous
    else
       grid=FALSE
    end if

    if (present(spacing)) then
       space = spacing
    else
       space=0
    end if

    if (present(horizontal)) then
       if (horizontal == TRUE) then
          box = gtk_hbox_new(grid, space)
       else
          box = gtk_vbox_new(grid, space)
       end if
    else
       box = gtk_vbox_new(grid, space)
    end if
  end function hl_gtk_box_new

  !+
  subroutine hl_gtk_box_pack(box, child, expand, fill, padding, atend)
    ! Put a widget into a box
    !
    ! BOX: c_ptr: required: The box into which to put the child
    ! CHILD: c_ptr: required: The child to pack
    ! EXPAND: boolean: optional: If TRUE then expand this child when
    ! 		filling the box, if FALSE don't, (Default TRUE)
    ! FILL: boolean: optional: If TRUE, then expand the widget when
    ! 		expanding, if FALSE, then put space round it. (Default TRUE,
    ! 		ignored if EXPAND==FALSE.
    ! PADDING: c_int: optional: Extra space to put around the child in the
    ! 		fill direction.
    ! ATEND: boolean: optional: If present and TRUE, then put the child at
    ! 		the end of the box rather than the start.
    !-

    type(c_ptr), intent(in) :: box, child
    integer(kind=c_int), intent(in), optional :: expand, fill
    integer(kind=c_int), intent(in), optional :: padding
    integer(kind=c_int), intent(in), optional :: atend

    integer(kind=c_int) :: iexp, ifill, ipad, iend

    if (present(expand)) then
       iexp = expand
    else
       iexp = TRUE
    end if
    if (present(fill)) then
       ifill = fill
    else
       ifill = TRUE
    end if
    if (present(padding)) then
       ipad = padding
    else
       ipad = 0
    end if
    if (present(atend)) then
       iend = atend
    else
       iend = FALSE
    end if

    call gtk_box_pack_start(box, child, iexp, ifill, ipad)
  end subroutine hl_gtk_box_pack

  !*
  ! Sliders and Spin buttons
  ! GTK sliders and spin buttons use floating point values, the HL interface
  ! implements an automatic interface selection between a floating point or
  ! an integer slider.
  !
  ! Although they belong to completely different widget families in GTK, the
  ! interfaces are very similar, which is why they are grouped together here.
  !/
  !+
  function hl_gtk_slider_flt_new(vmin, vmax, step, vertical, initial_value, &
       & value_changed, data, digits, sensitive, tooltip, draw, length) &
       & result(slider)
    ! Floating point version of a slider
    !
    ! VMIN: c_double: required: The minimum value for the slider
    ! VMAX: c_double: required: The maximum value for the slider
    ! STEP: c_double: required: The step for the slider.
    ! VERTICAL: boolean: optional: if TRUE then a vertical slider is created
    ! 		if FALSE or absent, then a horizontal silder is created.
    ! INITIAL_VALUE: c_double: optional: Set the intial value of the slider
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! DIGITS: c_int: optional: Number of decimal places to show.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! DRAW: boolean: optional: Set to FALSE to suppress writing the
    ! 		value.
    ! LENGTH: c_int: optional: Set the length of the slider in pixels
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_slider_new
    !-
    type(c_ptr) :: slider
    real(kind=c_double), intent(in) :: vmin, vmax, step
    integer(kind=c_int), intent(in), optional :: vertical
    real(kind=c_double), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: digits
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: draw
    integer(kind=c_int), intent(in), optional :: length

    integer(kind=c_int) :: isvertical, idraw

    ! Create the slider
    if (present(vertical)) then
       isvertical = vertical
    else
       isvertical = FALSE
    end if
    if (isvertical == TRUE) then
       slider = gtk_vscale_new_with_range(vmin, vmax, step)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, -1, length)
    else
       slider = gtk_hscale_new_with_range(vmin, vmax, step)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, length, -1)
    end if

    ! Formatting
    if (present(draw)) then
       idraw = draw
    else
       idraw = TRUE
    end if
    call gtk_scale_set_draw_value(slider, idraw)
    if (present(digits)) call gtk_scale_set_digits(slider, digits)

    ! Initial value
    if (present(initial_value)) call gtk_range_set_value(slider, initial_value)

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(slider, "value-changed", value_changed, data)
       else
          call g_signal_connect(slider, "value-changed", value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(slider, &
         & trim(tooltip)//cnull)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(slider, sensitive)
  end function hl_gtk_slider_flt_new

  !+
  function hl_gtk_slider_int_new(imin, imax, vertical, initial_value, &
       & value_changed, data, sensitive, tooltip, draw, length) result(slider)
    ! Floating point version of a slider
    !
    ! IMIN: c_int: required: The minimum value for the slider
    ! IMAX: c_int: required: The maximum value for the slider
    ! VERTICAL: boolean: optional: if TRUE then a vertical slider is created
    ! 		if FALSE or absent, then a horizontal silder is created.
    ! INITIAL_VALUE: c_int: optional: Set the intial value of the slider
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! DRAW: boolean: optional: Set to FALSE to suppress writing the
    ! 		value.
    ! LENGTH: c_int: optional: Set the length of the slider in pixels
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_slider_new
    !-
    type(c_ptr) :: slider
    integer(kind=c_int), intent(in) :: imin, imax
    integer(kind=c_int), intent(in), optional :: vertical
    integer(kind=c_int), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: draw
    integer(kind=c_int), intent(in), optional :: length

    integer(kind=c_int) :: isvertical, idraw

    ! Create the slider
    if (present(vertical)) then
       isvertical = vertical
    else
       isvertical = FALSE
    end if
    if (isvertical == TRUE) then
       slider = gtk_vscale_new_with_range(real(imin, c_double), &
            &real(imax, c_double), 1.0_c_double)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, -1, length)
    else
       slider = gtk_hscale_new_with_range(real(imin, c_double), &
            &real(imax, c_double), 1.0_c_double)
       if (present(length)) &
            & call gtk_widget_set_size_request(slider, length, -1)
    end if

    ! Formatting
    if (present(draw)) then
       idraw = draw
    else
       idraw = TRUE
    end if
    call gtk_scale_set_draw_value(slider, idraw)

    ! Initial value
    if (present(initial_value)) call gtk_range_set_value(slider, &
         & real(initial_value, c_double))

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(slider, "value-changed", value_changed, data)
       else
          call g_signal_connect(slider, "value-changed", value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(slider, &
         & trim(tooltip)//cnull)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(slider, sensitive)
  end function hl_gtk_slider_int_new

  !+
  function hl_gtk_slider_get_value(slider) result(val)
    ! Get the value of a slider
    !
    ! SLIDER: c_ptr: required: The slider to read.
    !
    ! Note even for an integer slider we get a float value but there's
    ! no problem letting Fortran do the truncation
    !-
    real(kind=c_double) :: val
    type(c_ptr) :: slider

    val = gtk_range_get_value(slider)
  end function hl_gtk_slider_get_value

  !+
  subroutine hl_gtk_slider_set_flt(slider, val)
    ! Set a floating point value for a slider
    !
    ! SLIDER: c_ptr: required: The slider to set.
    ! VAL: c_double: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_slider_set_value
    !-
    type(c_ptr), intent(in) :: slider
    real(kind=c_double), intent(in) :: val

    call gtk_range_set_value(slider, val)
  end subroutine hl_gtk_slider_set_flt

  !+
  subroutine hl_gtk_slider_set_int(slider, val)
    ! Set a floating point value for a slider
    !
    ! SLIDER: c_ptr: required: The slider to set.
    ! VAL: c_int: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_slider_set_value
    !-
    type(c_ptr), intent(in) :: slider
    integer(kind=c_int), intent(in) :: val

    call gtk_range_set_value(slider, real(val, c_double))
  end subroutine hl_gtk_slider_set_int

  !+
  function hl_gtk_spin_button_flt_new(vmin, vmax, step, initial_value, &
       & value_changed, data, digits, sensitive, tooltip, wrap) &
       & result(spin_button)
    ! Floating point version of a spin_button
    !
    ! VMIN: c_double: required: The minimum value for the spin_button
    ! VMAX: c_double: required: The maximum value for the spin_button
    ! STEP: c_double: required: The step for the spin_button.
    ! INITIAL_VALUE: c_double: optional: Set the intial value of the spin_button
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! DIGITS: c_int: optional: Number of decimal places to show.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! WRAP: boolean: optional: If set to TRUE then wrap around if limit is
    ! 		exceeded
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_spin_button_new
    !-
    type(c_ptr) :: spin_button
    real(kind=c_double), intent(in) :: vmin, vmax, step
    real(kind=c_double), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: digits
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: wrap

    integer(kind=c_int) :: isvertical, idraw

    ! Create the spin_button
    spin_button = gtk_spin_button_new_with_range(vmin, vmax, step)

    ! Formatting
    call gtk_spin_button_set_numeric(spin_button, TRUE)
    if (present(digits)) call gtk_spin_button_set_digits(spin_button, digits)
    if (present(wrap)) call gtk_spin_button_set_wrap(spin_button, wrap)

    ! Initial value
    if (present(initial_value)) &
         & call gtk_spin_button_set_value(spin_button, initial_value)

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(spin_button, "value-changed", value_changed, &
               & data)
       else
          call g_signal_connect(spin_button, "value-changed", value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(spin_button, &
         & trim(tooltip)//cnull)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(spin_button, sensitive)
  end function hl_gtk_spin_button_flt_new

  !+
  function hl_gtk_spin_button_int_new(imin, imax, initial_value, &
       & value_changed, data, sensitive, tooltip, wrap) result(spin_button)
    ! Floating point version of a spin_button
    !
    ! IMIN: c_int: required: The minimum value for the spin_button
    ! IMAX: c_int: required: The maximum value for the spin_button
    ! INITIAL_VALUE: c_int: optional: Set the intial value of the spin_button
    ! VALUE_CHANGED: c_funptr: optional: Callback function for the
    ! 		"value-changed" signal.
    ! DATA: c_ptr: optional: User data to pass the the value_changed callback.
    ! SENSITIVE: boolean: optional: Whether the widget is created in the
    ! 		sensitive state.
    ! TOOLTIP: string: optional: A tooltip to display.
    ! WRAP: boolean: optional: If set to TRUE then wrap around if limit is
    ! 		exceeded
    !
    ! This routine is usually called via its generic interface
    ! hl_gtk_spin_button_new
    !-
    type(c_ptr) :: spin_button
    integer(kind=c_int), intent(in) :: imin, imax
    integer(kind=c_int), intent(in), optional :: initial_value
    type(c_funptr), optional :: value_changed
    type(c_ptr), optional :: data
    integer(kind=c_int), optional, intent(in) :: sensitive
    character(len=*), intent(in), optional:: tooltip ! NB the C-type confuses generic interfaces.
    integer(kind=c_int), intent(in), optional :: wrap

    integer(kind=c_int) :: isvertical, idraw

    ! Create the spin_button
    spin_button = gtk_spin_button_new_with_range(real(imin, c_double), &
         &real(imax, c_double), 1.0_c_double)

    ! Formatting
    call gtk_spin_button_set_numeric(spin_button, TRUE)
    if (present(wrap)) call gtk_spin_button_set_wrap(spin_button, wrap)

    ! Initial value
    if (present(initial_value)) call gtk_spin_button_set_value(spin_button, &
         & real(initial_value, c_double))

    ! Callback connection
    if (present(value_changed)) then
       if (present(data)) then
          call g_signal_connect(spin_button, "value-changed", value_changed, &
               & data)
       else
          call g_signal_connect(spin_button, "value-changed", value_changed)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(spin_button, &
         & trim(tooltip)//cnull)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(spin_button, sensitive)
  end function hl_gtk_spin_button_int_new

  !+
  function hl_gtk_spin_button_get_value(spin_button) result(val)
    ! Get the value of a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to read.
    !
    ! Note even for an integer spin_button we get a float value but there's
    ! no problem letting Fortran do the truncation
    !-
    real(kind=c_double) :: val
    type(c_ptr) :: spin_button

    val = gtk_spin_button_get_value(spin_button)
  end function hl_gtk_spin_button_get_value

  !+
  subroutine hl_gtk_spin_button_set_flt(spin_button, val)
    ! Set a floating point value for a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to set.
    ! VAL: c_double: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_spin_button_set_value
    !-
    type(c_ptr), intent(in) :: spin_button
    real(kind=c_double), intent(in) :: val

    call gtk_spin_button_set_value(spin_button, val)
  end subroutine hl_gtk_spin_button_set_flt

  !+
  subroutine hl_gtk_spin_button_set_int(spin_button, val)
    ! Set a floating point value for a spin_button
    !
    ! SPIN_BUTTON: c_ptr: required: The spin_button to set.
    ! VAL: c_int: required: The value to set.
    !
    ! This is usually accessed via the generic interface hl_gtk_spin_button_set_value
    !-
    type(c_ptr), intent(in) :: spin_button
    integer(kind=c_int), intent(in) :: val

    call gtk_spin_button_set_value(spin_button, real(val, c_double))
  end subroutine hl_gtk_spin_button_set_int

  !*
  ! Multi-line text box
  ! This is based around the GtkTextView widget family. The HL interface hides
  ! the text buffer from the user, except in some callbacks where the signal
  ! is attached to the buffer not the view.
  !
  ! If you do need to access the text buffer directly it can be obtained with
  ! the gtk_text_view_get_buffer function.
  !/

  !+
  function hl_gtk_text_view_new(scroll, editable, activate, data_activate, &
       & insert_text, data_insert_text, delete_range, data_delete_range, &
       & initial_text, sensitive, tooltip, ssize) result(view)
    ! A multiline text edit widget
    !
    ! SCROLL: c_ptr: required?: A scrolled window in which the text editor
    ! 		is placed. [Should this be required?] used for packing the
    ! 		widget into your application.
    ! EDITABLE: boolean: optional: Set to FALSE to make a non-editable text box.
    ! ACTIVATE: c_funptr: optional: Callback for the "activate" signal.
    ! DATA_ACTIVATE: c_ptr: optional: User data to pass to/from the activate
    ! 		callback
    ! INSERT_TEXT: c_funptr: optional: Callback for the "insert-text" signal.
    ! 		This handler is attached to the text buffer not the text view.
    ! DATA_INSERT_TEXT: c_ptr: optional: User data for the insert-text callback.
    ! DELETE_RANGE: c_funptr: optional: Callback for the "delete-range" signal.
    ! 		This handler is attached to the text buffer not the text view.
    ! DATA_DELETE_RANGE: c_ptr: optional: User data for the delete-range callback.
    ! INITIAL_TEXT: string(): optional: Initial text to put in the text window.
    ! SENSITIVE: boolean: optional: Set to FALSE to make the widget start in an
    ! 		insensitive state.
    ! TOOLTIP: string: optional: A tooltip to display when the pointer is
    ! 		held over the widget.
    ! SSIZE: c_int(2): optional: Size of the scroll widget.
    !-

    type(c_ptr) :: view
    type(c_ptr), intent(out) :: scroll
    integer(kind=c_int), intent(in), optional :: editable
    type(c_funptr), optional :: activate, insert_text, delete_range
    type(c_ptr), optional :: data_activate, data_insert_text, data_delete_range
    character(len=*), dimension(:), intent(in), optional :: initial_text
    integer(kind=c_int), intent(in), optional :: sensitive
    character(kind=c_char), dimension(*), optional :: tooltip
    integer(kind=c_int), dimension(:), optional :: ssize

    type(c_ptr) :: buffer
    character(kind=c_char), dimension(:), allocatable :: text0
    type(gtktextiter), target :: iter

    buffer = gtk_text_buffer_new(NULL)
    view = gtk_text_view_new_with_buffer(buffer)

    scroll = gtk_scrolled_window_new(NULL, NULL)
    call gtk_scrolled_window_set_policy(scroll, GTK_POLICY_AUTOMATIC, &
         & GTK_POLICY_AUTOMATIC)
    if (present(ssize)) call gtk_widget_set_size_request(scroll,ssize(1), ssize(2))
    call gtk_container_add(scroll, view)

    if (present(editable)) then
       call gtk_text_view_set_editable(view, editable)
    else
       call gtk_text_view_set_editable(view, TRUE)
    end if

    ! If there's an initial value, set it before binding the signals.
    if (present(initial_text)) then
       call convert_f_string(initial_text, text0)
       call gtk_text_buffer_get_start_iter(buffer, c_loc(iter))
       call gtk_text_buffer_insert(buffer, c_loc(iter), text0, -1)
       deallocate(text0)
    end if

    ! Attach the various signals
    if (present(activate)) then
       if (present(data_activate)) then
          call g_signal_connect(view, "activate"//cnull, activate, &
               & data_activate)
       else
          call g_signal_connect(view, "activate"//cnull, activate)
       end if
    end if
    if (present(insert_text)) then
       if (present(data_insert_text)) then
          call g_signal_connect(buffer, "insert-text", insert_text, &
               & data_insert_text)
       else
          call g_signal_connect(buffer, "insert-text", insert_text)
       end if
    end if
    if (present(delete_range)) then
       if (present(data_delete_range)) then
          call g_signal_connect(buffer, "delete-range", delete_range, &
               & data_delete_range)
       else
          call g_signal_connect(buffer, "delete-range", delete_range)
       end if
    end if

    if (present(sensitive)) call gtk_widget_set_sensitive(view, sensitive)
    if (present(tooltip)) call gtk_widget_set_tooltip_text(view, tooltip)

  end function hl_gtk_text_view_new

  !+
  subroutine hl_gtk_text_view_insert(view, text, line, column, replace, &
       & at_cursor, buffer)
    ! Insert text to an text view
    !
    ! VIEW: c_ptr: required: The text view into which to insert.
    ! TEXT: string(): required: The text to insert.
    ! LINE: c_int: optional: The line at which to insert (if omitted,
    ! 		then the text is appended).
    ! COLUMN: c_int: optional: The column as which to insert the text
    ! 		(If omitted, then insert at the start of the line).
    ! REPLACE: boolean: optional: If set to TRUE and LINE and COLUMN are omitted
    ! 		then replace the text in the buffer.
    ! AT_CURSOR: boolean: optional: Set to TRUE to insert the text at the
    ! 		cursor. 
    ! BUFFER: c_ptr: optional: The text buffer in which to insert the text
    ! 		If this is given, then VIEW is ignored -- used in signal
    ! 		handlers attached to the buffer.
    !-

    type(c_ptr), intent(in) :: view
    character(len=*), dimension(:), intent(in) :: text
    integer(kind=c_int), optional, intent(in) :: line, column
    integer(kind=c_int), optional, intent(in) :: replace, at_cursor
    type(c_ptr), intent(in), optional :: buffer

    type(c_ptr) :: tbuf
    type(gtktextiter), target :: iter
    integer(kind=c_int) :: icol, irep, atc
    character(kind=c_char), dimension(:), allocatable :: text0

    if (present(buffer)) then
       tbuf = buffer
    else
       tbuf= gtk_text_view_get_buffer(view)
    end if

    call convert_f_string(text, text0)

    ! Check if we are going to insert at the cursor, and if so do so.
    if (present(at_cursor)) then
       atc = at_cursor
    else
       atc = FALSE
    end if

    if (atc == TRUE) then
       call gtk_text_buffer_insert_at_cursor(tbuf, text0, -1)
       deallocate(text0)
       return
    end if

    if (present(line)) then
       if (present(column)) then
          icol = column
       else
          icol = 0
       end if
       if (present(replace)) then 
          call hl_gtk_text_view_delete(NULL, line=line, column=icol, &
               & n_chars=size(text0), buffer=tbuf)
       end if
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(iter), &
            & line, column)
    else
       if (present(replace)) then
          irep = replace
       else
          irep = FALSE
       end if
       if (irep == TRUE) then
          call gtk_text_buffer_set_text(tbuf, text0, -1)
          deallocate(text0)
          return
       end if
       call gtk_text_buffer_get_end_iter(tbuf, c_loc(iter))
    end if

    call gtk_text_buffer_insert(tbuf, c_loc(iter), text0, -1)
    deallocate(text0)
  end subroutine hl_gtk_text_view_insert

  !+
  subroutine hl_gtk_text_view_delete(view, line, column, n_chars, n_lines, &
       & buffer)
    ! Delete from a text view
    !
    ! VIEW: c_ptr: required: The text view from which to delete.
    ! LINE: c_int: optional: The line at which to start the deletion
    ! COLUMN: c_int: optional: The column at which to start the deletion.
    ! 		required if N_CHARS is given. Ignored if N_LINES is given.
    ! N_CHARS: c_int: optional: How many characters to delete. 
    ! N_LINES: c_int: optional: How many lines to delete.
    ! BUFFER: c_ptr: optional: The text buffer from which to delete. If this
    ! 		is given, then VIEW is ignored, used in signal handlers
    ! 		attached to the buffer.
    !
    ! If no location specifiers are given then the buffer is cleared
    !-

    type(c_ptr), intent(in) :: view
    integer(kind=c_int), intent(in), optional :: line, column, n_chars, n_lines
    type(c_ptr), intent(in), optional :: buffer

    type(c_ptr) :: tbuf
    type(gtktextiter), target :: s_iter, e_iter
    integer(kind=c_int) :: isok

    ! Input checking
    if (present(n_chars) .and. present(n_lines)) then
       write(0, *) &
            & "hl_gtk_text_view_delete:: May not specify both N_CHARS and N_LINES"
       return
    end if

    if (present(n_chars) .and. .not. present(column)) then
       write(0, *) &
            & "hl_gtk_text_view_delete:: Character delete requires a start column"
       return
    end if

    ! Find the buffer

    if (present(buffer)) then
       tbuf = buffer
    else
       tbuf = gtk_text_view_get_buffer(view)
    end if

    if (present(n_chars)) then
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(s_iter), &
            & line, column)
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(e_iter), &
            & line, column)
       isok = gtk_text_iter_forward_chars(c_loc(e_iter), n_chars)
    else if (present(n_lines)) then
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(s_iter), line)
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(e_iter), line)
       isok = gtk_text_iter_forward_lines(c_loc(e_iter), n_lines)
    else
       call gtk_text_buffer_get_start_iter(tbuf, c_loc(s_iter))
       call gtk_text_buffer_get_end_iter(tbuf, c_loc(s_iter))
    end if

    call gtk_text_buffer_delete(tbuf, c_loc(s_iter), c_loc(e_iter))
  end subroutine hl_gtk_text_view_delete

  !+
  subroutine hl_gtk_text_view_get_text(view, text, start_line, start_column, &
       & end_line, end_column, hidden, buffer)
    ! Get text from s text view.
    !
    ! VIEW: c_ptr: required: The text view to read.
    ! TEXT: string(): required: A variable to contain the output text.
    ! START_LINE: c_int: optional: The first line to read.
    ! START_COLUMN: c_int: optional: The column at which to start reading.
    ! END_LINE: c_int: optional: The last line to read.
    ! END_COLUMN: c_int: optional: The column at which to stop reading.
    ! HIDDEN: boolean: optional: If set to FALSE, then do not get hidden
    ! 		characters
    ! BUFFER: c_ptr: optional: The text buffer from which to read. If this
    ! 		is given, then VIEW is ignored, useful for signal handlers
    ! 		attached to the buffer.
    !
    ! Note the rules for selection.
    !
    ! * If no selection arguments are present, the whole text is returned.
    ! * If either start_column or end_column is absent, but the matching line
    ! is present, then selection is by line.
    ! * If end_line is absent, but both columns are present, then the selection
    ! is within start_line
    ! * If neither start_line nor start_column is present, then the selection is
    ! from the start of the buffer
    ! * If neither end_line nor end_column is present, then the selection is
    ! to the end of the buffer.
    !-

    type(c_ptr), intent(in) :: view
    character(len=*), dimension(:), allocatable, intent(out) :: text
    integer(kind=c_int), intent(in), optional :: start_column, start_line, &
         & end_line, end_column
    integer(kind=c_int), intent(in), optional :: hidden
    type(c_ptr), intent(in), optional :: buffer

    type(c_ptr) :: tbuf, ctext0
    character(kind=c_char), dimension(:), pointer :: ftext0
    type(gtktextiter), target :: s_iter, e_iter
    integer(kind=c_int) :: ihid
    integer(kind=c_int) :: nchars_r

    if (present(buffer)) then
       tbuf = buffer
    else
       tbuf = gtk_text_view_get_buffer(view)
    end if

    ! Fully specified
    if (present(start_line) .and. present(start_column) .and. &
         & present(end_line) .and. present(end_column)) then
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(s_iter), &
            & start_line, start_column)
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(e_iter), &
            & end_line, end_column)

       ! Both columns only start line
    else if (present(start_line) .and. present(start_column) .and. &
         &  present(end_column)) then
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(s_iter), &
            & start_line, start_column)
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(e_iter), &
            & start_line, end_column)

       ! Both lines, at least one column not given
    else if (present(start_line) .and. present(start_column)) then
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(s_iter), &
            & start_line)
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(e_iter), &
            & end_line)

       ! Fully specified start, no end
    else if (present(start_line) .and. present(start_column)) then
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(s_iter), &
            & start_line, start_column)
       call gtk_text_buffer_get_end_iter(tbuf, c_loc(e_iter))

       ! Start line only
    else if (present(start_line)) then
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(s_iter), &
            & start_line)
       call gtk_text_buffer_get_end_iter(tbuf, c_loc(e_iter))

       ! Fully specified end, no start
    else if (present(end_line) .and. present(end_column)) then
       call gtk_text_buffer_get_start_iter(tbuf, c_loc(s_iter))
       call gtk_text_buffer_get_iter_at_line_offset(tbuf, c_loc(e_iter), &
            & start_line, end_column)

       ! End line only
    else if (present(end_line)) then
       call gtk_text_buffer_get_start_iter(tbuf, c_loc(s_iter))
       call gtk_text_buffer_get_iter_at_line(tbuf, c_loc(e_iter), &
            & end_line)

       ! Should only get here with nothing specified
    else
       call gtk_text_buffer_get_start_iter(tbuf, c_loc(s_iter))
       call gtk_text_buffer_get_end_iter(tbuf, c_loc(e_iter))
    end if

    if (present(hidden)) then
       ihid = hidden
    else
       ihid = TRUE
    end if
    ctext0 = gtk_text_buffer_get_text(tbuf, c_loc(s_iter), c_loc(e_iter), ihid)
    nchars_r = gtk_text_iter_get_offset(c_loc(e_iter)) - &
         &gtk_text_iter_get_offset(c_loc(s_iter)) + 1

    call c_f_pointer(ctext0, ftext0, (/ nchars_r /))
    call convert_c_string(ftext0, text)

  end subroutine hl_gtk_text_view_get_text

  !+
  function hl_gtk_text_view_get_cursor(view, buffer) result(ipos)
    ! Get the current cursor location
    !
    ! VIEW: c_ptr: required: The text view to query
    ! BUFFER: c_ptr: optional: The buffer to query (if given, then
    ! 		VIEW is ignored).
    !
    ! Returns a 2-element array with the line and column of the cursor
    !-

    integer(kind=c_int), dimension(2) :: ipos
    type(c_ptr), intent(in) :: view
    type(c_ptr), intent(in), optional :: buffer

    type(c_ptr) :: tbuf, mark
    type(gtktextiter), target :: iter

    if (present(buffer)) then
       tbuf = buffer
    else
       tbuf = gtk_text_view_get_buffer(view)
    end if

    mark = gtk_text_buffer_get_insert(tbuf)
    call gtk_text_buffer_get_iter_at_mark(tbuf, c_loc(iter), mark)
    ipos(1) = gtk_text_iter_get_line(c_loc(iter))
    ipos(2) = gtk_text_iter_get_line_offset(c_loc(iter))

  end function hl_gtk_text_view_get_cursor

  !+
  function hl_gtk_text_view_get_selection(view, s_start, s_end, buffer) &
       & result(issel)
    ! Get the selection range 
    !
    ! VIEW: c_ptr: required: The text view to query.
    ! S_START: c_int(): required: The start of the selection. (line, column)
    ! S_END: c_int(): required: The end of the selection. (line, column)
    ! BUFFER: c_ptr: optional: The text buffer to query. If present, then the
    ! 		view argument is ignored.
    !
    ! Returns TRUE if there is a selection, FALSE if there isn't
    !-

    integer(kind=c_int) :: issel
    type(c_ptr), intent(in) :: view
    integer(kind=c_int), dimension(2), intent(out) :: s_start, s_end
    type(c_ptr), intent(in), optional :: buffer

    type(c_ptr) :: tbuf
    type(gtktextiter), target :: s_iter, e_iter

    if (present(buffer)) then
       tbuf = buffer
    else
       tbuf = gtk_text_view_get_buffer(view)
    end if

    issel = gtk_text_buffer_get_selection_bounds(tbuf, c_loc(s_iter), &
         & c_loc(e_iter))

    if (issel == FALSE) then ! No selection
       s_start(:) = -1
       s_end(:) = -1
    else
       s_start(1) = gtk_text_iter_get_line(c_loc(s_iter))
       s_start(2) = gtk_text_iter_get_line_offset(c_loc(s_iter))
       s_end(1) = gtk_text_iter_get_line(c_loc(e_iter))
       s_end(2) = gtk_text_iter_get_line_offset(c_loc(e_iter))
    end if
  end function hl_gtk_text_view_get_selection

  !+
  function hl_gtk_text_view_get_modified(view) result(ismod)
    ! Check if the buffer of a text view is modified
    !
    ! VIEW: c_ptr: required: The text view to check.
    !
    ! N.B. No BUFFER argument is provided as gtk_text_buffer_get_modified
    ! is just a single call
    !-

    integer(kind=c_int) :: ismod
    type(c_ptr), intent(in) :: view

    type(c_ptr) :: tbuf

    tbuf = gtk_text_view_get_buffer(view)
    ismod = gtk_text_buffer_get_modified(tbuf) 

  end function hl_gtk_text_view_get_modified

  !+
  subroutine hl_gtk_text_view_set_modified(view, state)
    ! Set/clear the modified flag on the text buffer of a text view
    !
    ! VIEW: c_ptr: required: The text view to set
    ! STATE: boolean: required: The state to set the flag to.
    !-

    type(c_ptr), intent(in) :: view
    integer(kind=c_int), intent(in) :: state

    type(c_ptr) :: tbuf

    tbuf = gtk_text_view_get_buffer(view)
    call gtk_text_buffer_set_modified(tbuf, state)

  end subroutine hl_gtk_text_view_set_modified

end module gtk_hl
