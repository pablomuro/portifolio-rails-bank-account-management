$(function(){
    // toastr.info('Are you the 6 fingered man?')

    var notice = $('#notice')
    var hasNotice = notice.length > 0 && notice.text() !== ''

    var alert = $('#alert')
    var hasAlert = alert.length > 0 && alert.text() !== ''

    if(hasNotice){
        toastr.success(notice.text(), 'Success')
    }

    if(hasAlert){
        toastr.error(alert.text(), 'Error')
    }
})