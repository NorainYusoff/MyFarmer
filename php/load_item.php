<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM ITEM ORDER BY ITEM_ID DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["item"] = array();
    while ($row = $result ->fetch_assoc()){
        $itemlist = array();
        $itemlist[itemid] = $row["ITEM_ID"];
        $itemlist[itemtitle] = $row["ITEM_TITLE"];
        $itemlist[itemprice] = $row["ITEM_PRICE"];
        $itemlist[itemdesc] = $row["ITEM_DESC"];
        $itemlist[itemowner] = $row["ITEM_OWNER"];
        $itemlistt[itemtime] = date_format(date_create($row["ITEM_TIME"]), 'd/m/Y h:i:s');
        $itemlist[itemimage] = $row["ITEM_IMAGE"];
        $itemlist[itemsrating] = $row["ITEM_RATING"];
        //$goodslist[radius] = $row["LATITUDE"];
       // if (distance($latitude,$longitude,$row["LATITUDE"],$row["LONGITUDE"])<$radius){
            array_push($response["item"], $itemlist);    
        //}
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>