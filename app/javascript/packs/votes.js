$(document).on("turbolinks:load", function () {
    $(".btn-vote")
        .on("ajax:success", function (e) {
            console.log(e.detail);
            let votesResult = e.detail[0];

            $(
                '.vote-result[data-vote-id="' +
                votesResult.name +
                "-" +
                votesResult.id +
                '"]'
            ).text(votesResult.rating);
        })
        .on("ajax:error", function (e) {
            console.log(e.detail[0].message);
            let resource = e.detail[0];
            $.each(resource.message, function (index, value) {
                $('#errors-' + resource.id + '-' + resource.name ).prepend(
                    '<div class="alert alert-danger" >' + value+ "</div>"
                );
            });
        });
});
