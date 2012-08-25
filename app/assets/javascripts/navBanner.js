// JavaScript Document

$(document).ready(function() {      
    
    //Execute the slideShow
    // http://www.queness.com/post/152/simple-jquery-image-slide-show-with-semi-transparent-caption
    slideShow();
    $('#hp_banner img.hideButton').removeClass('hideButton');
});

function slideShow() {
    
    //Set the opacity of all images to 0
    $('#hp_banner a.item').css({opacity: 0.0});
    
    //Set the first element based on the random INT
    initial = $('#hp_banner a.item:eq('+Math.floor(Math.random()*($('#hp_banner a.item').length))+')');     
    
    //Get the first image and display it (set it to full opacity)
    initial.css({opacity: 1.0});
    
    //Set the Class so the Gallery knows where to navigate from
    initial.addClass('show');
    
    //Get the caption of the first image from REL attribute and display it
   $('#hp_banner .hp_banner_text').html(initial.find('img').attr('rel') + (' <a href="'+initial.attr('href')+'" target="'+initial.find('img').attr('linktarget')+'"> '+initial.find('img').attr('linklabel')+'</a>')); //.animate({opacity: 1.0}, 400);
    
    //Call the gallery function to run the slideshow, 6000 = change to next image after 6 seconds
    gallertInt = setInterval('gallery("")',4000);
    
}

function navItem(DIR) {
    clearInterval(gallertInt);
    if (DIR != 'pause') {
        gallertInt = setInterval('gallery("'+DIR+'")',10000);
        gallery(DIR);
    }
}

function gallery(DIR) {
    
    //if no IMGs have the show class, grab the first image
    var current = ( $('#hp_banner a.show') ?  $('#hp_banner a.show') : $('#hp_banner a.item:first') );
    
    //Calculate next slide based on direction
    if (DIR == "prev") {
        var next = ((current.prev().length) ? ((current.prev().hasClass('caption')) ? $('#hp_banner a.item:last') : current.prev()) : $('#hp_banner a.item:last'));     
    } else {
        var next = ((current.next().length) ? ((current.next().hasClass('loopStop')) ? $('#hp_banner a.item:first') : current.next()) : $('#hp_banner a.item:first'));
    }
    
    //Get next image caption
    var caption = next.find('img').attr('rel');
    var linkLabel = next.find('img').attr('linklabel'); 
    var linktarget =  next.find('img').attr('linktarget');
    
    //Set the fade in effect for the next image, show class has higher z-index
    next.css({opacity: 0.0}).addClass('show').animate({opacity: 1.0}, 800);

    //Hide the current image
    current.animate({opacity: 0.0}, 800).removeClass('show');

    //Display the caption
    $('#hp_banner .hp_banner_text').html(caption + ' <a href="'+next.attr('href')+'" target="'+linktarget+'"> '+linkLabel+'</a>');
}