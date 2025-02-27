function showToast(content){
    $('#toast').addClass("display");
    $('#toast').html(content);
    setTimeout(()=>{
        $('#toast').removeClass("display");
    },2000)
}