package sins.test.sampleject.dialog

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import sins.test.sampleject.R

class SBottomSheetDialogFragment: BottomSheetDialogFragment() {
    override fun getTheme() = R.style.BottomSheetDialogDimDiabled


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.dialog_bottom_sheet, container)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        initializeBottomSheet()
        val adapter = TestAdapter()
        val listView = view.findViewById<RecyclerView>(R.id.rv_list)
        listView.layoutManager = LinearLayoutManager(view.context)
        listView.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    private fun initializeBottomSheet() {
        val view: FrameLayout = dialog?.findViewById(R.id.design_bottom_sheet)!!
        view.layoutParams.height = ViewGroup.LayoutParams.MATCH_PARENT
        val behavior = BottomSheetBehavior.from(view)
        behavior.state = BottomSheetBehavior.STATE_EXPANDED
        behavior.skipCollapsed = true

        behavior.addBottomSheetCallback(object: BottomSheetBehavior.BottomSheetCallback(){
            override fun onStateChanged(bottomSheet: View, newState: Int) {
                if (newState == BottomSheetBehavior.STATE_COLLAPSED) {
//                    Log.d("test", "collapsed")
                }
            }

            override fun onSlide(bottomSheet: View, slideOffset: Float) {

            }
        })
    }

    class TestViewHolder(view: View): RecyclerView.ViewHolder(view) {

    }

    class TestAdapter: RecyclerView.Adapter<TestViewHolder>() {
        @SuppressLint("SetTextI18n")
        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TestViewHolder {
            val textView = AppCompatTextView(parent.context)
            textView.text = "TESTASDFASDETW"
            return TestViewHolder(textView)
        }

        override fun onBindViewHolder(holder: TestViewHolder, position: Int) {

        }

        override fun getItemCount(): Int {
            return 100
        }
    }
}